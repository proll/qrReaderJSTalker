Проект основан на http://www.libspark.org/wiki/QRCodeReader/en
﻿
# Описание
## Как работает
Что делает swf опрашивает камеру ищет QR код и пытаеться его распознать<br/>
По результату вызывает со страницы *метод js responseFromQRReader (txt)*<br/>
*txt может быть*
- no-camera - сбой при определении камеры или камера у пользователя не настроена или ее нет
- error - возникает когда расшифрованный код определяется неправильно по сравнению с предыдущим значением
- строка зашифрованная в QR

## QR коды
Чтобы определить QR нужно поднести ее в нарисованную на экране рамку - она поблескивает кода происходит особытие успешного определения<br/>
Лучше всего определяются коды с большой рамочкой вокруг и с большим процентом ошибки заложенном в при кодировании QR<br/>
*Пример хорошего QR кода:*<br/>
[https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20world&choe=UTF-8&chld=H](https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20world&choe=UTF-8&chld=H)<br/>
Здесь error_correction_level = H = 30% и отступ margin = 4 ряда (по умолчанию у google api)<br/>
Описание [https://developers.google.com/chart/infographics/docs/qr_codes#details](https://developers.google.com/chart/infographics/docs/qr_codes#details)<br/>

# Использование
## Пример вставки на страницу 
Тот самый swf - bin/qrReaderJSTalker.swf<br/>
Пример вставки написан в bin/index.html, там используется swfobject.js для этого<br/>
Можно вставить просто html тэгом если не расчитываем на старые версии ie (как обычную swf).
*Пример:*<br/>
```html
<object type='application/x-shockwave-flash' data='bin/qrReaderJSTalker.swf' width='320' height='240'>
	<param name='allowScriptAccess' value='always' />
	<param name='movie' value='bin/qrReaderJSTalker.swf' />
	<param name='bgcolor' value='#FFFFFF'>
	<param name='menu' value='false'>
	<param name='scale' value='noScale'>
</object>
```
