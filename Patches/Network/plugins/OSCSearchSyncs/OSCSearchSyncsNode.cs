#region usings
using System;
using System.ComponentModel.Composition;

using VVVV.PluginInterfaces.V1;
using VVVV.PluginInterfaces.V2;
using VVVV.Utils.VColor;
using VVVV.Utils.VMath;
using VVVV.Utils.OSC;
using VVVV.Core.Logging;
#endregion usings

namespace VVVV.Nodes
{
	#region PluginInfo
	[PluginInfo(Name = "SearchSyncs", Category = "OSC", Help = "Basic template with one string in/out", Tags = "")]
	#endregion PluginInfo
	public class OSCSearchSyncsNode : IPluginEvaluate
	{
		#region fields & pins
		[Input("Input", DefaultString = "hello c#")]
		ISpread<string> FInput;

		[Output("Output")]
		ISpread<string> FOutput;

		[Import()]
		ILogger FLogger;
		#endregion fields & pins

		//called when data for any output pin is requested
		public void Evaluate(int SpreadMax)
		{
			FOutput.SliceCount = SpreadMax;
			
			if (FInput[0] == "")
				return;
			
			OSCReceiver rx =new OSCReceiver();
			for (int i = 0; i < SpreadMax; i++)
				FOutput[i] = FInput[i].Replace("c#", "vvvv");

			FLogger.Log(LogType.Debug, "Logging to Renderer (TTY)");
		}
	}
}
