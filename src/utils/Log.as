/**
 * Created by Dryaglin on 14.11.2015.
 */
package utils
{

	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Log
	{
		private static var tfDebug : TextField;

		public static function init( stage : Stage ) : void
		{
			tfDebug = new TextField();
			tfDebug.selectable = true;
			tfDebug.multiline = true;
			tfDebug.wordWrap = true;
			tfDebug.type = TextFieldType.DYNAMIC;
			tfDebug.defaultTextFormat = new TextFormat( "Arial", 12, 0x000000, false, false, false, null, null, TextFormatAlign.LEFT );
			tfDebug.x = 0;
			tfDebug.y = 20;
			tfDebug.width = 600;
			tfDebug.height = 380;
			tfDebug.background = false;
			tfDebug.border = false;

			stage.addChild( tfDebug );
		}

		public static function add( text : * ) : void
		{
			tfDebug.appendText( text + "\n" );
			tfDebug.scrollV = tfDebug.maxScrollV;
		}
	}
}
