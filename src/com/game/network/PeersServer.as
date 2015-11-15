/**
 * Created by Dryaglin on 15.11.2015.
 */
package com.game.network
{

	import appkit.responders.NResponder;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class PeersServer
	{
		private var mURLLoader : URLLoader;
		private var mURLRequest : URLRequest;

		public function PeersServer()
		{

		}

		public function getRivalPeer( selfPeer : String ) : void
		{
			mURLLoader = new URLLoader();
			mURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
			mURLLoader.addEventListener( Event.COMPLETE, mURLLoader_completeHandler );

			mURLRequest = new URLRequest();
			mURLRequest.url = Config.PEERS_SERVER + selfPeer;
			mURLRequest.method = URLRequestMethod.GET;

			mURLLoader.load( mURLRequest );

		}

		private function mURLLoader_completeHandler( event : Event ) : void
		{
			var data : Object = JSON.parse( mURLLoader.data );

			if ( data.self )
			{
				NResponder.dispatch( PeersServerEvents.WAITING_FOR_RIVAL );
			}
			else if ( data.rival )
			{
				NResponder.dispatch( PeersServerEvents.RIVAL_PEER_RECEIVE, [data] );
			}

			mURLLoader.removeEventListener( Event.COMPLETE, mURLLoader_completeHandler );
			mURLRequest = null;
			mURLLoader = null;
		}
	}
}
