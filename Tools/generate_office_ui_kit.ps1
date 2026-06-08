param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function New-OfficeColor([int]$A, [int]$R, [int]$G, [int]$B) {
    [System.Drawing.Color]::FromArgb($A, $R, $G, $B)
}

function New-RoundedPath([float]$X, [float]$Y, [float]$Width, [float]$Height, [float]$Radius) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $diameter = $Radius * 2
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-OfficeTexture(
    [System.Drawing.Graphics]$Graphics,
    [System.Drawing.RectangleF]$Rect,
    [System.Drawing.Color]$BaseColor,
    [int]$Seed,
    [int]$Alpha
) {
    $random = [System.Random]::new($Seed)
    for ($i = 0; $i -lt 900; $i++) {
        $x = [float]($Rect.X + 2 + $random.NextDouble() * ($Rect.Width - 4))
        $y = [float]($Rect.Y + 2 + $random.NextDouble() * ($Rect.Height - 4))
        $shade = $random.Next(-8, 9)
        $r = [Math]::Max(0, [Math]::Min(255, $BaseColor.R + $shade))
        $g = [Math]::Max(0, [Math]::Min(255, $BaseColor.G + $shade))
        $b = [Math]::Max(0, [Math]::Min(255, $BaseColor.B + $shade))
        $pen = [System.Drawing.Pen]::new((New-OfficeColor $Alpha $r $g $b), [float](0.45 + $random.NextDouble() * 0.9))
        $length = [float](1.5 + $random.NextDouble() * 7)
        $Graphics.DrawLine($pen, $x, $y, $x + $length, $y + [float]($random.NextDouble() * 1.4 - 0.7))
        $pen.Dispose()
    }
}

function Save-OfficeSprite(
    [string]$Path,
    [int]$Width,
    [int]$Height,
    [System.Drawing.Color]$BaseColor,
    [System.Drawing.Color]$EdgeColor,
    [System.Drawing.Color]$InnerColor,
    [ValidateSet("button", "paper", "modal")]
    [string]$Kind,
    [int]$Seed
) {
    $bitmap = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $pad = [Math]::Max(8, [Math]::Round([Math]::Min($Width, $Height) * 0.045))
    $radius = [Math]::Max(8, [Math]::Round([Math]::Min($Width, $Height) * 0.055))
    if ($Kind -eq "paper") {
        $radius = [Math]::Max(10, [Math]::Round([Math]::Min($Width, $Height) * 0.05))
    }
    elseif ($Kind -eq "modal") {
        $radius = [Math]::Max(8, [Math]::Round([Math]::Min($Width, $Height) * 0.06))
    }

    $shadowPath = New-RoundedPath ($pad + 2) ($pad + 3) ($Width - $pad * 2 - 2) ($Height - $pad * 2 - 2) $radius
    $shadowBrush = [System.Drawing.SolidBrush]::new((New-OfficeColor 46 0 0 0))
    $graphics.FillPath($shadowBrush, $shadowPath)
    $shadowBrush.Dispose()
    $shadowPath.Dispose()

    $bodyRect = [System.Drawing.RectangleF]::new([float]$pad, [float]$pad, [float]($Width - $pad * 2 - 3), [float]($Height - $pad * 2 - 3))
    $bodyPath = New-RoundedPath $bodyRect.X $bodyRect.Y $bodyRect.Width $bodyRect.Height $radius
    $bodyBrush = [System.Drawing.SolidBrush]::new($BaseColor)
    $graphics.FillPath($bodyBrush, $bodyPath)
    $bodyBrush.Dispose()

    $state = $graphics.Save()
    $graphics.SetClip($bodyPath)
    Draw-OfficeTexture $graphics $bodyRect $BaseColor $Seed 19
    $graphics.Restore($state)

    $edgePen = [System.Drawing.Pen]::new($EdgeColor, [float]1.7)
    $graphics.DrawPath($edgePen, $bodyPath)
    $edgePen.Dispose()

    $innerPad = [Math]::Max(8, [Math]::Round([Math]::Min($Width, $Height) * 0.055))
    $innerRect = [System.Drawing.RectangleF]::new(
        [float]($pad + $innerPad),
        [float]($pad + $innerPad),
        [float]($Width - $pad * 2 - $innerPad * 2 - 3),
        [float]($Height - $pad * 2 - $innerPad * 2 - 3))
    $innerPath = New-RoundedPath $innerRect.X $innerRect.Y $innerRect.Width $innerRect.Height ([Math]::Max(5, $radius - 4))
    $innerPen = [System.Drawing.Pen]::new($InnerColor, [float]1.2)
    $graphics.DrawPath($innerPen, $innerPath)
    $innerPen.Dispose()

    if ($Kind -eq "button") {
        $foldBrush = [System.Drawing.SolidBrush]::new((New-OfficeColor 28 $InnerColor.R $InnerColor.G $InnerColor.B))
        $graphics.FillRectangle($foldBrush, ($pad + $innerPad), ($pad + $innerPad), 16, 4)
        $graphics.FillRectangle($foldBrush, ($Width - $pad - $innerPad - 16), ($Height - $pad - $innerPad - 4), 16, 4)
        $foldBrush.Dispose()
    }
    elseif ($Kind -eq "paper") {
        $tabPen = [System.Drawing.Pen]::new((New-OfficeColor 74 $EdgeColor.R $EdgeColor.G $EdgeColor.B), [float]1.7)
        $graphics.DrawLine($tabPen, $innerRect.X + 20, $innerRect.Y + 2, $innerRect.X + 62, $innerRect.Y + 2)
        $graphics.DrawLine($tabPen, $innerRect.X + 20, $innerRect.Y + 2, $innerRect.X + 20, $innerRect.Y + 28)
        $graphics.DrawLine($tabPen, $innerRect.Right - 62, $innerRect.Bottom - 2, $innerRect.Right - 20, $innerRect.Bottom - 2)
        $graphics.DrawLine($tabPen, $innerRect.Right - 20, $innerRect.Bottom - 28, $innerRect.Right - 20, $innerRect.Bottom - 2)
        $tabPen.Dispose()
    }
    else {
        $cornerPen = [System.Drawing.Pen]::new((New-OfficeColor 50 $InnerColor.R $InnerColor.G $InnerColor.B), [float]1.7)
        $corner = 20
        $graphics.DrawLine($cornerPen, $bodyRect.X + 10, $bodyRect.Y + $corner, $bodyRect.X + $corner, $bodyRect.Y + 10)
        $graphics.DrawLine($cornerPen, $bodyRect.Right - 10, $bodyRect.Y + $corner, $bodyRect.Right - $corner, $bodyRect.Y + 10)
        $graphics.DrawLine($cornerPen, $bodyRect.X + 10, $bodyRect.Bottom - $corner, $bodyRect.X + $corner, $bodyRect.Bottom - 10)
        $graphics.DrawLine($cornerPen, $bodyRect.Right - 10, $bodyRect.Bottom - $corner, $bodyRect.Right - $corner, $bodyRect.Bottom - 10)
        $cornerPen.Dispose()
    }

    $innerPath.Dispose()
    $bodyPath.Dispose()
    $graphics.Dispose()
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
}

$artRoot = Join-Path $ProjectRoot "Assets\Resources\Art"
if (-not (Test-Path $artRoot)) {
    throw "Art root not found: $artRoot"
}

$sprites = @(
    @{ Name = "ui_button_primary_generated.png"; Width = 424; Height = 221; Base = @(238, 74, 86, 52); Edge = @(138, 122, 105, 70); Inner = @(104, 186, 159, 96); Kind = "button"; Seed = 101 },
    @{ Name = "ui_button_secondary_generated.png"; Width = 413; Height = 209; Base = @(232, 39, 50, 55); Edge = @(124, 113, 113, 102); Inner = @(92, 166, 157, 138); Kind = "button"; Seed = 102 },
    @{ Name = "ui_button_utility_generated.png"; Width = 266; Height = 173; Base = @(226, 48, 50, 45); Edge = @(112, 122, 113, 92); Inner = @(80, 166, 151, 112); Kind = "button"; Seed = 103 },
    @{ Name = "ui_button_analysis_generated.png"; Width = 298; Height = 202; Base = @(230, 49, 64, 67); Edge = @(118, 118, 132, 126); Inner = @(86, 173, 179, 170); Kind = "button"; Seed = 104 },
    @{ Name = "ui_button_danger_generated.png"; Width = 313; Height = 187; Base = @(230, 82, 48, 43); Edge = @(120, 132, 99, 83); Inner = @(84, 186, 137, 116); Kind = "button"; Seed = 105 },
    @{ Name = "ui_button_tab_generated.png"; Width = 423; Height = 199; Base = @(224, 59, 57, 50); Edge = @(108, 133, 121, 96); Inner = @(76, 176, 155, 116); Kind = "button"; Seed = 106 },
    @{ Name = "ui_action_rail_generated.png"; Width = 440; Height = 179; Base = @(166, 33, 37, 36); Edge = @(80, 105, 103, 91); Inner = @(58, 170, 160, 132); Kind = "modal"; Seed = 107 },
    @{ Name = "ui_hotkey_badge_generated.png"; Width = 188; Height = 179; Base = @(214, 63, 58, 43); Edge = @(104, 142, 126, 91); Inner = @(74, 197, 174, 118); Kind = "button"; Seed = 108 },
    @{ Name = "ui_panel_modal_generated.png"; Width = 284; Height = 238; Base = @(188, 30, 39, 39); Edge = @(72, 95, 113, 109); Inner = @(50, 139, 156, 150); Kind = "modal"; Seed = 109 },
    @{ Name = "ui_panel_paper_generated.png"; Width = 415; Height = 258; Base = @(236, 222, 205, 171); Edge = @(108, 122, 95, 67); Inner = @(74, 129, 103, 75); Kind = "paper"; Seed = 110 }
)

foreach ($sprite in $sprites) {
    $path = Join-Path $artRoot $sprite.Name
    $base = $sprite.Base
    $edge = $sprite.Edge
    $inner = $sprite.Inner
    Save-OfficeSprite `
        -Path $path `
        -Width $sprite.Width `
        -Height $sprite.Height `
        -BaseColor (New-OfficeColor -A $base[0] -R $base[1] -G $base[2] -B $base[3]) `
        -EdgeColor (New-OfficeColor -A $edge[0] -R $edge[1] -G $edge[2] -B $edge[3]) `
        -InnerColor (New-OfficeColor -A $inner[0] -R $inner[1] -G $inner[2] -B $inner[3]) `
        -Kind $sprite.Kind `
        -Seed $sprite.Seed
    Write-Host "Generated $($sprite.Name)"
}
