Пример [http://prolll.com/qrReaderJSTalker/bin/](http://prolll.com/qrReaderJSTalker/bin/)

Project based on http://www.libspark.org/wiki/QRCodeReader/en
# How it works?
SWF is calling a camera, trying to find QR code and then trying to decode it<br/>
On result is calls onpage **function js responseFromQRReader (state)**<br/>
**state can be**
- *no-camera* - error on camera detection or user has uninstalled camera or he just hasn't it
- *error* - it appears when detected QR is different from previous one
- a string encoded in QR

# QR codes
To detect QR you have to show it to your camera (for better recognition please set it to the square on the screen)<br/>
It is better if QR codes had big margin and not a small percent of errors in the QR coded algorithmbr/>
**Example of a good QR:**<br/>
[https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20world&choe=UTF-8&chld=H](https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20world&choe=UTF-8&chld=H)<br/>
Here error_correction_level = H = 30% and margin = 4 rows (by default google api)<br/>
Description [https://developers.google.com/chart/infographics/docs/qr_codes#details](https://developers.google.com/chart/infographics/docs/qr_codes#details)<br/>

# Html embed example
The SWF - bin/qrReaderJSTalker.swf<br/>
Html embed example bin/index.html, it uses swfobject.js<br/><br/>
**Example:**
```html
<object type='application/x-shockwave-flash' data='bin/qrReaderJSTalker.swf' width='320' height='240'>
	<param name='allowScriptAccess' value='always' />
	<param name='movie' value='bin/qrReaderJSTalker.swf' />
	<param name='bgcolor' value='#FFFFFF'>
	<param name='menu' value='false'>
	<param name='scale' value='noScale'>
</object>
```