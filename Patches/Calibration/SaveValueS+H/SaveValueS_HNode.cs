#region usings
using System;
using System.ComponentModel.Composition;

using VVVV.PluginInterfaces.V1;
using VVVV.PluginInterfaces.V2;
using VVVV.Utils.VColor;
using VVVV.Utils.VMath;

using VVVV.Core.Logging;
#endregion usings

namespace VVVV.Nodes
{
	#region PluginInfo
	[PluginInfo(Name = "S+H", Category = "Value", Version = "Save", AutoEvaluate=true, Author="elliotwoods", Help = "S+H that saves state into the patch", Tags = "")]
	#endregion PluginInfo
	public class SaveValueS_HNode : IPluginEvaluate
	{
		#region fields & pins
		[Config("Save")]
		IDiffSpread<string> FSave;
		
		[Input("Input", DefaultValue = 1.0)]
		ISpread<double> FInput;
		
		[Input("Set")]
		ISpread<bool> FSet;
		
		[Output("Output")]
		ISpread<double> FOutput;

		[Import()]
		ILogger FLogger;
		#endregion fields & pins

		//called when data for any output pin is requested
		public void Evaluate(int SpreadMax)
		{
			if (FSave.IsChanged)
			{
				Load();
			}
			
			FOutput.SliceCount = SpreadMax;

			bool save = false;
			for (int i = 0; i < SpreadMax; i++)
				if (FSet[i])
				{
					FOutput[i] = FInput[i];
					save = true;
				}
			if (save)
				Save();
		}
		
		void Load()
		{
			string[] values = FSave[0].Split(new char[]{','});
			int count = values.Length;
			FOutput.SliceCount = count;
			
			double v;
			for (int i=0; i<count; i++)
			{
				if (Double.TryParse(values[i], out v))
					FOutput[i] = v;
				else
					FOutput[i] = 0;
			}
			//FLogger.Log(LogType.Debug, "Load");
		}
		void Save()
		{
			string o = "";
			int count = FOutput.SliceCount;
			for (int i=0; i<count; i++)
			{
				o += Convert.ToString(FOutput[i]) + ",";
			}
			FSave[0] = o;
			//FLogger.Log(LogType.Debug, "Save");
		}
	}
}
