/**
 * Created by Dryaglin on 15.11.2015.
 */
package com.game.network
{

	import utils.Log;

	public class Client extends Object
	{
		public function Client()
		{
			super();
		}

		public function live( data : * ) : void
		{
			Log.add( data );
		}
	}
}
