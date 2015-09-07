$var_distropointARL="\\CEGCCFP3\C2S2DP"
$var_distropointCAM="\\PROD-CAM-FS1\C2S2DP"
$var_distropointCHA="\\AMS-CE-CH-FS1\C2S2DP"
$var_distropointDUM="\\PROD-DUM-FS1\C2S2DP"
$var_distropointETN="\\FS1\C2S2DP"
$var_distropointHOR="\\PROD-HOR-BKP2\C2S2DP"
$var_distropointJAC="\\JAX-FS1\C2S2DP"
$var_distropointLEX="\\LEX-IT\C2S2DP"
$var_distropointMOU="\\AMS-MAR-FS1\C2S2DP"
$var_distropointMIS="\\MIMVTSDFS\C2S2DP"
$var_distropointORL="\\PROD-ORL-FS1\C2S2DP"
$var_distropointPAN="\\MIPCFS1\C2S2DP"
$var_distropointSTA="\\AMS-MI-STAF-FPS1\C2S2DP"
$var_distropointSTF="\\PROD-STF-FS1\C2S2DP"
$var_distropointTOR="\\ESD-FILE2\C2S2DP"
$var_distropointVAB="\\PROD-VAB-FS6\C2S2DP"

$snap1 = Get-ChildItem -Recurse $var_distropointETN
$snap2 = Get-ChildItem -Recurse $var_distropointDUM

Compare-Object $snap1 $snap2 -syncWindow 30 -Property Name | Where-Object {$_.SideIndicator -eq '<='} | ForEach-Object -Process { Copy-Item -Path (Join-Path $var_distropointETN $_.FullName) -Destination $var_distropointDUM }