package
{
	
	public class StatsManager
	{
		
		public function StatsManager():void
		{
		
		}
		
		public static function percentage(total:int, current:int):Number
		{
			return (current * 100) / total;
		}
	
	}
}