$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$rows = @(
    @{ label='BACKEND'; subtitle='Python / API / Data'; items=@(@('python','Python'),@('fastapi','FastAPI'),@('django','Django'),@('postgresql','PostgreSQL')) },
    @{ label='FRONTEND'; subtitle='Web interfaces'; items=@(@('html5','HTML'),@('css','CSS'),@('javascript','JavaScript')) },
    @{ label='TOOLS'; subtitle='Dev environment'; items=@(@('git','Git'),@('docker','Docker'),@('linux','Linux')) }
)
$parts = New-Object 'Collections.Generic.List[string]'
$parts.Add('<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="316" viewBox="0 0 1200 316"><title>Backend: Python, FastAPI, Django, PostgreSQL. Frontend: HTML, CSS, JavaScript. Tools: Git, Docker, Linux.</title><rect x=".5" y=".5" width="1199" height="315" rx="14" fill="#0d1410" stroke="#2e3e28"/>')
for ($rowIndex=0; $rowIndex -lt $rows.Count; $rowIndex++) {
    $row=$rows[$rowIndex]
    $y=40+88*$rowIndex
    $parts.Add("<text x=`"40`" y=`"$($y+23)`" font-family=`"Consolas,monospace`" font-size=`"19`" letter-spacing=`"1.5`" fill=`"#c4fa6a`">$($row.label)</text><text x=`"40`" y=`"$($y+47)`" font-family=`"Segoe UI,Arial,sans-serif`" font-size=`"16`" fill=`"#9eb885`">$($row.subtitle)</text>")
    if ($rowIndex -gt 0) { $parts.Add("<path d=`"M40 $($y-18)H1160`" stroke=`"#253322`"/>") }
    for ($index=0; $index -lt $row.items.Count; $index++) {
        $item=$row.items[$index]
        $xml=[xml](Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root "assets/icons/$($item[0]).svg"))
        $logo=($xml.DocumentElement.ChildNodes | Where-Object LocalName -eq 'path' | ForEach-Object { '<path d="'+$_.GetAttribute('d')+'"/>' }) -join ''
        $x=254+226*$index
        $parts.Add("<g transform=`"translate($x $y)`"><rect x=`".5`" y=`".5`" width=`"209`" height=`"51`" rx=`"8`" fill=`"#152014`" stroke=`"#34472b`"/><g transform=`"translate(16 13) scale(1.083333)`" fill=`"#c4fa6a`">$logo</g><text x=`"56`" y=`"34`" font-family=`"Segoe UI,Arial,sans-serif`" font-size=`"22`" font-weight=`"500`" fill=`"#c4fa6a`">$($item[1])</text></g>")
    }
}
$parts.Add('</svg>')
[IO.File]::WriteAllText((Join-Path $root 'assets/stack-grouped.svg'),($parts -join "`n"),(New-Object Text.UTF8Encoding($false)))
