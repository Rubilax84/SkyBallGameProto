/**
 * Created by Dryaglin on 14.11.2015.
 */
package com.game.network
{

	import appkit.responders.NResponder;

	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	import utils.Log;

	public class Cirrus
	{
		private const cirrusServer : String = 'rtmfp://p2p.rtmfp.net/';
		private var cirrusKey : String;
		private var directNetConnection : NetConnection;
		private var mPeerID : String;

		public function Cirrus( devKey : String )
		{
			if ( !devKey || devKey == '' )
				throw new Error( 'Enter valid cirrus developer key!!!' );

			cirrusKey = devKey;

			Log.add( '[Cirrus engine created]' );
		}

		public function connect() : void
		{
			Log.add( '[Start connecting...]' );

			if ( directNetConnection ) return;

			directNetConnection = new NetConnection();

			directNetConnection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus_Handler );
			directNetConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onError );
			directNetConnection.addEventListener( IOErrorEvent.IO_ERROR, onError );
			directNetConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onError );

			directNetConnection.connect( cirrusServer, cirrusKey );
		}

		protected function onNetStatus_Handler( event : NetStatusEvent ) : void
		{
			Log.add( '[Net status:' + event.info.code + ']' );

			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":
				{
					connectionSuccess_Handler();
					break;
				}
				case "NetGroup.Connect.Success":
				{
					break;
				}
				case "NetGroup.Neighbor.Disconnect":
				{
					break;
				}
				case "NetGroup.SendTo.Notify":
				{
					break;
				}
				case "NetGroup.Posting.Notify":
				{
					break;
				}
				case "NetGroup.Neighbor.Connect":
				{
					break;
				}
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.IdleTimeout":
				case "NetGroup.Connect.Rejected":
				case "NetGroup.Connect.Failed":
				{
					NResponder.dispatch( CirrusEvents.CONNECTION_ERROR );
					break;
				}
			}
		}

		private function connectionSuccess_Handler() : void
		{
			Log.add( '[Connection info]' );
			Log.add( '[nearID :' + directNetConnection.nearID + ']' );
			Log.add( '[farID  :' + directNetConnection.farID + ']' );

			mPeerID = directNetConnection.nearID;

			NResponder.dispatch( CirrusEvents.CONNECTION_SUCCESS );
		}

		private function onError( e : ErrorEvent ) : void
		{
			Log.add( e );
			NResponder.dispatch( CirrusEvents.CONNECTION_ERROR );
		}

		public function createNetStreem( leftPeerID : String, rightPeerID : String ) : void
		{
			/*sendStream = new NetStream(directNetConnection, NetStream.DIRECT_CONNECTIONS);
			 sendStream.publish("gameData");

			 var client:Object = {};

			 client.onPeerConnect = function(subscriber:NetStream):Boolean
			 {
			 return true;
			 };

			 sendStream.client = client;

			 leftPlayerStream = new NetStream(directNetConnection, leftPeerID);

			 leftPlayerStream.play("leftPlayerData");
			 leftPlayerStream.client = new GameClient();

			 rightPlayerStream = new NetStream(directNetConnection, rightPeerID);

			 rightPlayerStream.play("rightPlayerData");
			 rightPlayerStream.client = new GameClient();*/
		}

		public function get peerID() : String
		{
			return mPeerID;
		}
	}
}
