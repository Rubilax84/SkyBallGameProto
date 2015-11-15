/**
 * Created by Dryaglin on 14.11.2015.
 */
package com.game.network
{

	import appkit.responders.NResponder;

	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	import utils.Log;

	public class Cirrus
	{
		private const cirrusServer : String = 'rtmfp://p2p.rtmfp.net/';
		private var cirrusKey : String;
		private var directNetConnection : NetConnection;
		private var mPeerID : String;
		private var outStream : NetStream;
		private var receiveStream : NetStream;

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
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.IdleTimeout":
				case "NetGroup.Connect.Rejected":
				case "NetGroup.Connect.Failed":
				{
					Log.add( event.info.code );
					NResponder.dispatch( CirrusEvents.CONNECTION_ERROR );
					break;
				}
			}
		}

		private function connectionSuccess_Handler() : void
		{
			Log.add( '[Connection info]' );
			Log.add( 'nearID :' + directNetConnection.nearID );
			Log.add( 'farID  :' + directNetConnection.farID );

			mPeerID = directNetConnection.nearID;

			NResponder.add( PeersServerEvents.WAITING_FOR_RIVAL, waitingForRival );
			NResponder.add( PeersServerEvents.RIVAL_PEER_RECEIVE, onRivalPeerReceived );

			NResponder.dispatch( CirrusEvents.CONNECTION_SUCCESS );
		}

		private function waitingForRival() : void
		{
			Log.add( 'waitingForRival...' );

			outStream = new NetStream( directNetConnection, NetStream.DIRECT_CONNECTIONS );
			outStream.addEventListener( NetStatusEvent.NET_STATUS, sendStream_netStatusHandler );
			outStream.publish( "live" );

			var outStreamClient : Object = {};
			outStreamClient.onPeerConnect = function ( subscriber : NetStream ) : Boolean
			{
				Log.add( 'Connected peer id: ' + subscriber.farID );
				return true;
			};

			outStream.client = outStreamClient;
			directNetConnection.client = outStreamClient;

			var s : Sprite = new Sprite();
			s.addEventListener( Event.ENTER_FRAME, s_enterFrameHandler );
		}

		private function onRivalPeerReceived( data : Object ) : void
		{
			Log.add( 'RivalPeerReceived...' );

			receiveStream = new NetStream( directNetConnection, data.rival );
			receiveStream.addEventListener( NetStatusEvent.NET_STATUS, sendStream_netStatusHandler );

			receiveStream.play("live");

			receiveStream.client = new Client();

		}

		private function onError( e : ErrorEvent ) : void
		{
			Log.add( e );
			NResponder.dispatch( CirrusEvents.CONNECTION_ERROR );
		}

		public function createNetStreem( leftPeerID : String, rightPeerID : String ) : void
		{
			/*outStream = new NetStream(directNetConnection, NetStream.DIRECT_CONNECTIONS);
			 outStream.publish("gameData");

			 var client:Object = {};

			 client.onPeerConnect = function(subscriber:NetStream):Boolean
			 {
			 return true;
			 };

			 outStream.client = client;

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

		private function sendStream_netStatusHandler( event : NetStatusEvent ) : void
		{
			Log.add( JSON.stringify( event.info ) );
		}

		private function s_enterFrameHandler( event : Event ) : void
		{
			if ( outStream )
			{
				outStream.send( 'live', 1 );
			}
		}
	}
}
