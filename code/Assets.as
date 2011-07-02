//
// Our asset management class. All of our assets are contained as static variables here so we can easily access them
// from anywhere.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Assets {
		
		// Fonts.
		[Embed(source="../fonts/monomin_6x5.ttf", fontName="monomin",  embedAsCFF="false")] private var MonominFont:Class;
		[Embed(source="../fonts/propomin_5.ttf",  fontName="propomin", embedAsCFF="false")] private var PropominFont:Class;
		
		// Character sprites.
		[Embed(source="../images/ghost.png")] public static var GhostSprite:Class;
		[Embed(source="../images/office_worker.png")] public static var OfficeWorkerSprite:Class;
		[Embed(source="../images/construction_worker.png")] public static var ConstructionWorkerSprite:Class;
		
	}
	
}
