package
{

	import flash.display.Sprite;
	import flash.events.Event;

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
		}
	}
}
