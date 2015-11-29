if exists (select ImageTypeID from dbo.ImageType)
	return

insert imageType (extension, imageType) values ('','application/UNKNOWN')
insert imageType (extension, imageType) values ('.*','application/octet-stream')
insert imageType (extension, imageType) values ('.323','text/h323')
insert imageType (extension, imageType) values ('.acx','application/internet-property-stream')
insert imageType (extension, imageType) values ('.ai','application/postscript')
insert imageType (extension, imageType) values ('.aif','audio/x-aiff')
insert imageType (extension, imageType) values ('.aifc','audio/x-aiff')
insert imageType (extension, imageType) values ('.aiff','audio/x-aiff')
insert imageType (extension, imageType) values ('.asf','video/x-ms-asf')
insert imageType (extension, imageType) values ('.asr','video/x-ms-asf')
insert imageType (extension, imageType) values ('.asx','video/x-ms-asf')
insert imageType (extension, imageType) values ('.au','audio/basic')
insert imageType (extension, imageType) values ('.avi','video/x-msvideo')
insert imageType (extension, imageType) values ('.axs','application/olescript')
insert imageType (extension, imageType) values ('.bas','text/plain')
insert imageType (extension, imageType) values ('.bcpio','application/x-bcpio')
insert imageType (extension, imageType) values ('.bin','application/octet-stream')
insert imageType (extension, imageType) values ('.bmp','image/bmp')
insert imageType (extension, imageType) values ('.c','text/plain')
insert imageType (extension, imageType) values ('.cat','application/vnd.ms-pkiseccat')
insert imageType (extension, imageType) values ('.cdf','application/x-cdf')
insert imageType (extension, imageType) values ('.cer','application/x-x509-ca-cert')
insert imageType (extension, imageType) values ('.class','application/octet-stream')
insert imageType (extension, imageType) values ('.clp','application/x-msclip')
insert imageType (extension, imageType) values ('.cmx','image/x-cmx')
insert imageType (extension, imageType) values ('.cod','image/cis-cod')
insert imageType (extension, imageType) values ('.cpio','application/x-cpio')
insert imageType (extension, imageType) values ('.crd','application/x-mscardfile')
insert imageType (extension, imageType) values ('.crl','application/pkix-crl')
insert imageType (extension, imageType) values ('.crt','application/x-x509-ca-cert')
insert imageType (extension, imageType) values ('.csh','application/x-csh')
insert imageType (extension, imageType) values ('.css','text/css')
insert imageType (extension, imageType) values ('.dcr','application/x-director')
insert imageType (extension, imageType) values ('.der','application/x-x509-ca-cert')
insert imageType (extension, imageType) values ('.dir','application/x-director')
insert imageType (extension, imageType) values ('.dll','application/x-msdownload')
insert imageType (extension, imageType) values ('.dms','application/octet-stream')
insert imageType (extension, imageType) values ('.doc','application/msword')
insert imageType (extension, imageType) values ('.dot','application/msword')
insert imageType (extension, imageType) values ('.dvi','application/x-dvi')
insert imageType (extension, imageType) values ('.dxr','application/x-director')
insert imageType (extension, imageType) values ('.eps','application/postscript')
insert imageType (extension, imageType) values ('.etx','text/x-setext')
insert imageType (extension, imageType) values ('.evy','application/envoy')
insert imageType (extension, imageType) values ('.exe','application/octet-stream')
insert imageType (extension, imageType) values ('.fif','application/fractals')
insert imageType (extension, imageType) values ('.flr','x-world/x-vrml')
insert imageType (extension, imageType) values ('.gif','image/gif')
insert imageType (extension, imageType) values ('.gtar','application/x-gtar')
insert imageType (extension, imageType) values ('.gz','application/x-gzip')
insert imageType (extension, imageType) values ('.h','text/plain')
insert imageType (extension, imageType) values ('.hdf','application/x-hdf')
insert imageType (extension, imageType) values ('.hlp','application/winhlp')
insert imageType (extension, imageType) values ('.hqx','application/mac-binhex40')
insert imageType (extension, imageType) values ('.hta','application/hta')
insert imageType (extension, imageType) values ('.htc','text/x-component')
insert imageType (extension, imageType) values ('.htm','text/html')
insert imageType (extension, imageType) values ('.html','text/html')
insert imageType (extension, imageType) values ('.htt','text/webviewhtml')
insert imageType (extension, imageType) values ('.ico','image/x-icon')
insert imageType (extension, imageType) values ('.ief','image/ief')
insert imageType (extension, imageType) values ('.iii','application/x-iphone')
insert imageType (extension, imageType) values ('.ins','application/x-internet-signup')
insert imageType (extension, imageType) values ('.isp','application/x-internet-signup')
insert imageType (extension, imageType) values ('.jfif','image/pipeg')
insert imageType (extension, imageType) values ('.jpe','image/jpeg')
insert imageType (extension, imageType) values ('.jpeg','image/jpeg')
insert imageType (extension, imageType) values ('.jpg','image/jpeg')
insert imageType (extension, imageType) values ('.js','application/x-javascript')
insert imageType (extension, imageType) values ('.latex','application/x-latex')
insert imageType (extension, imageType) values ('.lha','application/octet-stream')
insert imageType (extension, imageType) values ('.lsf','video/x-la-asf')
insert imageType (extension, imageType) values ('.lsx','video/x-la-asf')
insert imageType (extension, imageType) values ('.lzh','application/octet-stream')
insert imageType (extension, imageType) values ('.m13','application/x-msmediaview')
insert imageType (extension, imageType) values ('.m14','application/x-msmediaview')
insert imageType (extension, imageType) values ('.m3u','audio/x-mpegurl')
insert imageType (extension, imageType) values ('.man','application/x-troff-man')
insert imageType (extension, imageType) values ('.mdb','application/x-msaccess')
insert imageType (extension, imageType) values ('.me','application/x-troff-me')
insert imageType (extension, imageType) values ('.mht','message/rfc822')
insert imageType (extension, imageType) values ('.mhtml','message/rfc822')
insert imageType (extension, imageType) values ('.mid','audio/mid')
insert imageType (extension, imageType) values ('.mny','application/x-msmoney')
insert imageType (extension, imageType) values ('.mov','video/quicktime')
insert imageType (extension, imageType) values ('.movie','video/x-sgi-movie')
insert imageType (extension, imageType) values ('.mp2','video/mpeg')
insert imageType (extension, imageType) values ('.mp3','audio/mpeg')
insert imageType (extension, imageType) values ('.mpa','video/mpeg')
insert imageType (extension, imageType) values ('.mpe','video/mpeg')
insert imageType (extension, imageType) values ('.mpeg','video/mpeg')
insert imageType (extension, imageType) values ('.mpg','video/mpeg')
insert imageType (extension, imageType) values ('.mpp','application/vnd.ms-project')
insert imageType (extension, imageType) values ('.mpv2','video/mpeg')
insert imageType (extension, imageType) values ('.ms','application/x-troff-ms')
insert imageType (extension, imageType) values ('.mvb','application/x-msmediaview')
insert imageType (extension, imageType) values ('.nws','message/rfc822')
insert imageType (extension, imageType) values ('.oda','application/oda')
insert imageType (extension, imageType) values ('.p10','application/pkcs10')
insert imageType (extension, imageType) values ('.p12','application/x-pkcs12')
insert imageType (extension, imageType) values ('.p7b','application/x-pkcs7-certificates')
insert imageType (extension, imageType) values ('.p7c','application/x-pkcs7-mime')
insert imageType (extension, imageType) values ('.p7m','application/x-pkcs7-mime')
insert imageType (extension, imageType) values ('.p7r','application/x-pkcs7-certreqresp')
insert imageType (extension, imageType) values ('.p7s','application/x-pkcs7-signature')
insert imageType (extension, imageType) values ('.pbm','image/x-portable-bitmap')
insert imageType (extension, imageType) values ('.pdf','application/pdf')
insert imageType (extension, imageType) values ('.pfx','application/x-pkcs12')
insert imageType (extension, imageType) values ('.pgm','image/x-portable-graymap')
insert imageType (extension, imageType) values ('.pko','application/ynd.ms-pkipko')
insert imageType (extension, imageType) values ('.pma','application/x-perfmon')
insert imageType (extension, imageType) values ('.pmc','application/x-perfmon')
insert imageType (extension, imageType) values ('.pml','application/x-perfmon')
insert imageType (extension, imageType) values ('.pmr','application/x-perfmon')
insert imageType (extension, imageType) values ('.pmw','application/x-perfmon')
insert imageType (extension, imageType) values ('.pnm','image/x-portable-anymap')
insert imageType (extension, imageType) values ('.pot,','application/vnd.ms-powerpoint')
insert imageType (extension, imageType) values ('.ppm','image/x-portable-pixmap')
insert imageType (extension, imageType) values ('.pps','application/vnd.ms-powerpoint')
insert imageType (extension, imageType) values ('.ppt','application/vnd.ms-powerpoint')
insert imageType (extension, imageType) values ('.prf','application/pics-rules')
insert imageType (extension, imageType) values ('.ps','application/postscript')
insert imageType (extension, imageType) values ('.pub','application/x-mspublisher')
insert imageType (extension, imageType) values ('.qt','video/quicktime')
insert imageType (extension, imageType) values ('.ra','audio/x-pn-realaudio')
insert imageType (extension, imageType) values ('.ram','audio/x-pn-realaudio')
insert imageType (extension, imageType) values ('.ras','image/x-cmu-raster')
insert imageType (extension, imageType) values ('.rgb','image/x-rgb')
insert imageType (extension, imageType) values ('.rmi','audio/mid')
insert imageType (extension, imageType) values ('.roff','application/x-troff')
insert imageType (extension, imageType) values ('.rtf','application/rtf')
insert imageType (extension, imageType) values ('.rtx','text/richtext')
insert imageType (extension, imageType) values ('.scd','application/x-msschedule')
insert imageType (extension, imageType) values ('.sct','text/scriptlet')
insert imageType (extension, imageType) values ('.setpay','application/set-payment-initiation')
insert imageType (extension, imageType) values ('.setreg','application/set-registration-initiation')
insert imageType (extension, imageType) values ('.sh','application/x-sh')
insert imageType (extension, imageType) values ('.shar','application/x-shar')
insert imageType (extension, imageType) values ('.sit','application/x-stuffit')
insert imageType (extension, imageType) values ('.snd','audio/basic')
insert imageType (extension, imageType) values ('.spc','application/x-pkcs7-certificates')
insert imageType (extension, imageType) values ('.spl','application/futuresplash')
insert imageType (extension, imageType) values ('.src','application/x-wais-source')
insert imageType (extension, imageType) values ('.sst','application/vnd.ms-pkicertstore')
insert imageType (extension, imageType) values ('.stl','application/vnd.ms-pkistl')
insert imageType (extension, imageType) values ('.stm','text/html')
insert imageType (extension, imageType) values ('.sv4cpio','application/x-sv4cpio')
insert imageType (extension, imageType) values ('.sv4crc','application/x-sv4crc')
insert imageType (extension, imageType) values ('.t','application/x-troff')
insert imageType (extension, imageType) values ('.tar','application/x-tar')
insert imageType (extension, imageType) values ('.tcl','application/x-tcl')
insert imageType (extension, imageType) values ('.tex','application/x-tex')
insert imageType (extension, imageType) values ('.texi','application/x-texinfo')
insert imageType (extension, imageType) values ('.texinfo','application/x-texinfo')
insert imageType (extension, imageType) values ('.tgz','application/x-compressed')
insert imageType (extension, imageType) values ('.tif','image/tiff')
insert imageType (extension, imageType) values ('.tiff','image/tiff')
insert imageType (extension, imageType) values ('.tr','application/x-troff')
insert imageType (extension, imageType) values ('.trm','application/x-msterminal')
insert imageType (extension, imageType) values ('.tsv','text/tab-separated-values')
insert imageType (extension, imageType) values ('.txt','text/plain')
insert imageType (extension, imageType) values ('.uls','text/iuls')
insert imageType (extension, imageType) values ('.ustar','application/x-ustar')
insert imageType (extension, imageType) values ('.vcf','text/x-vcard')
insert imageType (extension, imageType) values ('.vrml','x-world/x-vrml')
insert imageType (extension, imageType) values ('.wav','audio/x-wav')
insert imageType (extension, imageType) values ('.wcm','application/vnd.ms-works')
insert imageType (extension, imageType) values ('.wdb','application/vnd.ms-works')
insert imageType (extension, imageType) values ('.wks','application/vnd.ms-works')
insert imageType (extension, imageType) values ('.wmf','application/x-msmetafile')
insert imageType (extension, imageType) values ('.wps','application/vnd.ms-works')
insert imageType (extension, imageType) values ('.wri','application/x-mswrite')
insert imageType (extension, imageType) values ('.wrl','x-world/x-vrml')
insert imageType (extension, imageType) values ('.wrz','x-world/x-vrml')
insert imageType (extension, imageType) values ('.xaf','x-world/x-vrml')
insert imageType (extension, imageType) values ('.xbm','image/x-xbitmap')
insert imageType (extension, imageType) values ('.xla','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xlc','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xlm','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xls','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xlt','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xlw','application/vnd.ms-excel')
insert imageType (extension, imageType) values ('.xof','x-world/x-vrml')
insert imageType (extension, imageType) values ('.xpm','image/x-xpixmap')
insert imageType (extension, imageType) values ('.xwd','image/x-xwindowdump')
insert imageType (extension, imageType) values ('.z','application/x-compress')
insert imageType (extension, imageType) values ('.zip','application/zip')