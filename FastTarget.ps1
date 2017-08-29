$datapath1 = "$env:userprofile\documents"
$data1=Get-ChildItem $datapath1 -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum
if ($data1.Sum -gt 1073741824){Write-Host "`nMy Documents",("`nNumber of Files:              {0}" -f ($data1.Count)),"`nNumber of MBytes/GBytes:	 ",("{0:N2}" -f ($data1.sum / 1GB)),"GB"}
elseif ($data1.Sum -gt 1048576){Write-Host "`nMy Documents",("`nNumber of Files:              {0}" -f ($data1.Count)),"`nNumber of MBytes/GBytes:	 ",("{0:N2}" -f ($data1.sum / 1MB)),"MB"}
elseif ($data1.Sum -gt 1024){Write-Host "`nMy Documents",("`nNumber of Files:              {0}" -f ($data1.Count)),"`nNumber of MBytes/GBytes:	 ",("{0:N2}" -f ($data1.sum / 1KB)),"KB"}
else {Write-Host "`nMy Documents",("`nNumber of Files:              {0}" -f ($data1.Count)),"`nNumber of MBytes/GBytes:	 ",("{0:N2}" -f ($data1.sum)),"Bytes"}
