# Minimal static file server for local site verification
$prefix = 'http://localhost:8931/'
$root = 'D:\workspace\html\IT-English-Learning-System'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Output "serving $root at $prefix"
try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $path = $ctx.Request.Url.AbsolutePath
        if ($path -eq '/') { $path = '/index.html' }
        $file = Join-Path $root ($path -replace '/', '\')
        if ((Test-Path $file -PathType Leaf) -and ((Resolve-Path $file).Path.StartsWith($root))) {
            $ext = [System.IO.Path]::GetExtension($file).ToLower()
            $types = @{'.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'; '.js'='text/javascript; charset=utf-8';
                       '.svg'='image/svg+xml'; '.jpg'='image/jpeg'; '.png'='image/png'; '.xml'='text/xml; charset=utf-8';
                       '.txt'='text/plain; charset=utf-8'}
            $mime = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
            $bytes = [System.IO.File]::ReadAllBytes($file)
            $ctx.Response.ContentType = $mime
            $ctx.Response.ContentLength64 = $bytes.Length
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $ctx.Response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes('404 not found')
            $ctx.Response.ContentLength64 = $msg.Length
            $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
        }
        $ctx.Response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
}
