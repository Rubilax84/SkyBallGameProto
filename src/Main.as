package
{

	import appkit.responders.NResponder;

	import com.game.network.Cirrus;
	import com.game.network.CirrusEvents;
	import com.game.network.PeersServer;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import utils.Log;

	public class Main extends Sprite
	{
		private var cirrus : Cirrus;
		private var peerServer : PeersServer;

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

			NResponder.add( CirrusEvents.CONNECTION_SUCCESS, onCirrusConnect );

			cirrus = new Cirrus( Config.CIRRUS_DEV_KEY );
			cirrus.connect();

			Log.show();
		}

		private function onCirrusConnect() : void
		{
			peerServer = new PeersServer();
			peerServer.getRivalPeer( cirrus.peerID );
		}
	}
}
