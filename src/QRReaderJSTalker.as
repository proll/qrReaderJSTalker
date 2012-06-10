package 
{ 	/*
	
	Example program to detect QRcodes.
	Add 'ReadQrSimple' the the Document Class. 
	Publish for Flash Player 10.
	
	Based on ReadQrCodeSample by Kenichi UENO (http://keno.serio.jp/)
	> http://blog.jactionscripters.com/2009/05/23/introduction-of-qr-code-reader-library/
	> http://www.libspark.org/wiki/QRCodeReader/en
	
	Modified from orginal project : QRCodeDetecter.as, GetQRimage.as
	
	Implemented Adaptive Threshold by Quasimondo (Mario Klingemann) in the GetQRimage Class. 
	> http://www.quasimondo.com/archives/000690.php
	
	I've also added the substract blur method that Mario Klingemann explains in his lecture about the 
	process of reading QR codes. I've got less wrong strings in this mode and the detection runs faster.  
	You can set it to false, to use the	original method. 
	> http://tv.adobe.com/watch/max-2008-develop/here-be-pixels-by-mario-klingemann
	
	The outside parts of the video are cropped, to reduce image noise. By providing a markerGuide
	the user knows where to hold the marker. 
	
	The data from the onQrDecodeComplete event is compared with the data from a previous event as 
	a way of extra error correction. 	
	
	- TextArea (for debugging): 
	This script uses minimalcomps for the TextArea 
	Font is embedded in the Flex 3.x way. If you don't see text read this blog post: 
	 > http://www.bit-101.com/blog/?p=2555
	 > http://www.minimalcomps.com/
	
	- Stats (for debugging):
	Hi-ReS! stats by Mr. Doob
	> http://mrdoob.com/blog/post/582
	
	- Parameters
	GetQRimage(source:DisplayObject, cutRect:Rectangle = null, debug:Boolean = false, subtract:Boolean = false)
		
	- QR code generator:
	> http://qrcode.kaywa.com/
	
	*/
	
	
	import com.logosware.event.QRdecoderEvent;
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.QRcode.QRdecode;
	import com.logosware.utils.QRcode.GetQRimage;
	
	
	import net.hires.debug.Stats;
	
		
	import flash.display.*;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.display.Stage
	
	import flash.geom.Rectangle;
	
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	
	import flash.utils.*;

		
	[SWF(width = "320", height = "240", frameRate = "30", backgroundColor = "#FFFFFF")]
	
	public class QRReaderJSTalker extends Sprite 
	{	
		private var detectionRate:int = 10;
		
		private var getQRimage:GetQRimage;
		private var qrDecode:QRdecode;
		
		//string to save first decoded
		private var qrDecodedDataOld:String; 
		
		private var cam:Camera;
		private var video:Video;
		
		private var markerArea:uint;
		private var markerAreaRect:Rectangle;
		
		private var markerGuide:Sprite;
		private var markerGuideAniTimer:Number;
		
		private var refreshTimer:Timer;
		private var timesCompleted:uint = 0;
		
				
		public function QRReaderJSTalker():void 
		{	
			//displayDebugText();
									
			// initialize the webcam			
			cam = Camera.getCamera();
			
			if(cam != null)
			{	
				cam.setMode(320,240,25);
			
				video = new Video(cam.width, cam.height);
				video.attachCamera(cam);
				addChild(video);
				
				markerArea = 200;
				markerAreaRect = new Rectangle((cam.width-markerArea)/2,(cam.height-markerArea)/2,markerArea,markerArea);
								
				// set DisplayObject (Sprite, Video,..) that contains a QR code
				getQRimage = new GetQRimage(video, markerAreaRect, true, true);
				
				// run onQrImageReadComplete when the QR Code is found 
				getQRimage.addEventListener(QRreaderEvent.QR_IMAGE_READ_COMPLETE, onQrImageReadComplete);
				
				// setup QRdecoder object
				qrDecode = new QRdecode();
				
				// invoked when QR Code is found  
				qrDecode.addEventListener(QRdecoderEvent.QR_DECODE_COMPLETE, onQrDecodeComplete);
	
				// check the image n times a second (n = detectionRate)
				refreshTimer = new Timer(1000/detectionRate); 	
				refreshTimer.addEventListener(TimerEvent.TIMER, refresh);
				refreshTimer.start();
			}
			else
			{ 
				appSay("no-camera");
			}
			
			// display a guide where to put the marker	
			displayMarkerGuide();
			
			// add Mr. Doobs Hi-ReS! stats 
			//addChild( new Stats() );
		}
		
		// function call js interface and trace
		private function appSay(txt:String):void {	
			trace(txt);
			if (ExternalInterface.available) {
				ExternalInterface.call ("responseFromQRReader", txt);
			}
		}
		
		
		private function refresh( event:Event ):void
		{	// process webcam image and check for QRcode
			getQRimage.process();
		}
		
		private function onQrImageReadComplete(e:QRreaderEvent):void
		{	qrDecode.setQR(e.data);
			qrDecode.startDecode();		
		}
		
		private function onQrDecodeComplete(e:QRdecoderEvent):void
		{	// e.data is the string decoded from QR Code  
			timesCompleted++; // number times of recognition since start of program
			
			var decodedDataNew:String = e.data;
			
			
			clearInterval(markerGuideAniTimer);
			
			if(decodedDataNew.localeCompare(qrDecodedDataOld)==0)
			{ 
				appSay(e.data);
				markerGuide.alpha = 1;
				markerGuideAniTimer = setInterval (markerGuideAniToNormal, 50);
			}
			else
			{ 
				appSay("error");
			}
			

			
			qrDecodedDataOld = decodedDataNew;
		}
		
		private function markerGuideAniToNormal():void {
			if (markerGuide.alpha <= 0.3) {
				markerGuide.alpha = 0.3;
				clearInterval(markerGuideAniTimer);
			} else {
				markerGuide.alpha -= 0.05;
			}
		}
		
		private function displayMarkerGuide():void
		{	markerGuide = new Sprite();
			
			var guideLW:int = 10;
			var guideColor:uint = 0xFFFFFF;
			
			// make the MarkerGuide smaller than the markerArea
			// in this case users don't have to put the marker that precise in the area for detection
			var mRect:Rectangle = markerAreaRect;
			mRect.inflate(-40,-40)
			
			with(markerGuide.graphics) 
			{	lineStyle(guideLW, guideColor, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
				drawRect(mRect.x,mRect.y,mRect.width,mRect.height);
				lineStyle();
				beginFill(guideColor);
				drawRect(mRect.x+guideLW/2,mRect.y+guideLW/2,guideLW*2,guideLW*2);
				drawRect(mRect.x+mRect.width-(guideLW*2.5), mRect.y+guideLW/2,guideLW*2,guideLW*2);
				drawRect(mRect.x+guideLW/2, mRect.y+mRect.height-(guideLW*2.5),guideLW*2,guideLW*2);
				endFill();
			}
			markerGuide.alpha = 0.3;
			addChild(markerGuide);	
		}
	}
}