package
{

	import com.game.network.Cirrus;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import utils.Log;

	public class Main extends Sprite
	{
		public function Main()
		{
			if ( stage ) addedToStageHandler( null );
			else addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}

		private function addedToStageHandler( event : Event ) : void
		{
			if ( event ) removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );

			Log.init( this.stage );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var cirrus : Cirrus = new Cirrus( Config.CIRRUS_DEV_KEY );
			cirrus.connect();
		}
	}
}
