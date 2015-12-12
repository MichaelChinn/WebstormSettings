
rem Create Root Certificate Authority certificates
makecert -r -pe -n "CN=HocProfessional Test Root Authority" -ss CA -sr CurrentUser -a sha1 -sky signature -cy authority -sv CA.pvk CA.cer -len 2048

rem Create WildCard certificate
makecert -pe -n "CN=*.eval-wa.org" -a sha1 -len 2048 -sky exchange -eku 1.3.6.1.5.5.7.3.1 -ic CA.cer -iv CA.pvk -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12 -sv eval-wa.org.pvk eval-wa.org.cer

rem convert WildCard certificate to pfx format
pvk2pfx -pvk eval-wa.org.pvk -spc eval-wa.org.cer -pfx eval-wa.org.pfx
