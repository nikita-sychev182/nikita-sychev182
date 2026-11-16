$ErrorActionPreference = 'Stop'
$culture = [Globalization.CultureInfo]::InvariantCulture
$svg = New-Object Text.StringBuilder
[void]$svg.Append('<svg xmlns="http://www.w3.org/2000/svg" width="340" height="340" viewBox="-170 -170 340 340"><g fill="none" stroke="#c4fa6a" stroke-width="1" opacity=".8" stroke-linejoin="round">')
# Project a rotating 3D wireframe. SVG interpolates between these poses.
foreach ($family in 0,1) {
    $count = if ($family -eq 0) { 20 } else { 12 }
    for ($line = 0; $line -lt $count; $line++) {
        $poses = New-Object 'Collections.Generic.List[string]'
        for ($frame = 0; $frame -lt 48; $frame++) {
            $angle = 2 * [Math]::PI * $frame / 48
            $points = New-Object 'Collections.Generic.List[string]'
            for ($step = 0; $step -le 64; $step++) {
                $u = 2 * [Math]::PI * $(if ($family -eq 0) { $line / $count } else { $step / 64 })
                $v = 2 * [Math]::PI * $(if ($family -eq 0) { $step / 64 } else { $line / $count })
                $x = (125 + 38 * [Math]::Cos($v)) * [Math]::Cos($u)
                $y = (125 + 38 * [Math]::Cos($v)) * [Math]::Sin($u)
                $z = 38 * [Math]::Sin($v)
                $xx = $x * [Math]::Cos($angle) + $z * [Math]::Sin($angle)
                $zz = -$x * [Math]::Sin($angle) + $z * [Math]::Cos($angle)
                $yy = $y * [Math]::Cos(.72) - $zz * [Math]::Sin(.72)
                $depth = $y * [Math]::Sin(.72) + $zz * [Math]::Cos(.72)
                $screenX = $xx * [Math]::Cos(-.22) - $yy * [Math]::Sin(-.22)
                $screenY = $xx * [Math]::Sin(-.22) + $yy * [Math]::Cos(-.22)
                $perspective = 900 / (900 - $depth)
                $points.Add(($screenX * $perspective).ToString('0.0', $culture) + ',' + ($screenY * $perspective).ToString('0.0', $culture))
            }
            $poses.Add(($points -join ' '))
        }
        $poses.Add($poses[0])
        [void]$svg.Append('<polyline points="' + $poses[0] + '"><animate attributeName="points" dur="16s" repeatCount="indefinite" values="' + ($poses -join ';') + '"/></polyline>')
    }
}
[void]$svg.Append('</g></svg>')
[IO.File]::WriteAllText((Join-Path (Split-Path -Parent $PSScriptRoot) 'assets/torus-animated.svg'), $svg.ToString(), (New-Object Text.UTF8Encoding($false)))
