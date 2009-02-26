package io.radical.waterwall.net {
	
	import edu.iu.vis.net.AbstractLocalConnection;
	
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;

	public class WWAbstractConnection extends AbstractLocalConnection {
		
		public function WWAbstractConnection( connectionName:String, autoConnect:Boolean = false ){
			super(connectionName, autoConnect);
			registerClassAlias( "flash.utils.Dictionary", Dictionary );
		}
		
	}
}