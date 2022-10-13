//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick			2.8
import QtQuick.Layouts	1.3
import JASP.Controls	1.0
import JASP.Widgets		1.0
import JASP				1.0

// All Analysis forms must be built with the From QML item
Form
{
	columns: 1

	info: qsTr("Descriptives allows the user to obtain basic descriptive statistics, histograms and density plots, correlation plots, boxplots, and frequency tables.")

	VariablesForm
	{
		AvailableVariablesList	{ name: "allVariablesList"								}
		AssignedVariablesList	{ name: "variables";		title: qsTr("Variables");	info: qsTr("All variables of interest.")	}
		AssignedVariablesList	{ name: "splitBy";			title: qsTr("Split");		info: qsTr("Specify a variable by which to split the results.");		singleVariable: true; suggestedColumns: ["ordinal", "nominal"];	id: splitBy }
	}

	CheckBox
	{
		name	: "descriptivesTableTransposed"
		label	: qsTr("Transpose descriptives table")
		checked	: false
		info	: qsTr("Transposes the main descriptives table")
	}

	Section
	{
		title: qsTr("Statistics")

		Group
		{
			title: qsTr("Sample size")
			CheckBox { name: "valid";			label: qsTr("Valid");	checked: true;	info:	qsTr("Return the number of valid cases.")		}
			CheckBox { name: "missing";			label: qsTr("Missing");	checked: true;	info:	qsTr("Return the Number of missing cases.")	}
		}

		Group
		{
			title:	qsTr("Quantiles")

			CheckBox { name: "quartiles";	label: qsTr("Quartiles");	info:	qsTr("Return quartiles.") }
			CheckBox
			{
				name:				"quantilesForEqualGroups"; label: qsTr("Cut points for: ")
				childrenOnSameRow:	true
				info:	qsTr("Return quantiles for equal groups.")

				IntegerField
				{
					name:			"quantilesForEqualGroupsNumber"
					min:			2
					max:			1000
					defaultValue:	4
					afterLabel:		qsTr(" equal groups")
					info:			qsTr("The number of groups to return the quantiles for.")
				}
			}

			CheckBox
			{
				name:				"percentiles"
				label:				qsTr("Percentiles:")
				childrenOnSameRow:	true
				info:				qsTr("Return percentiles.")

				TextField
				{
					inputType:	"doubleArray"
					name:		"percentileValues"
					fieldWidth: 60
					info:		qsTr("The percentile values.")
				}
			}
		}

		Group
		{
			title: qsTr("Central tendency")

			CheckBox { name: "mode";			label: qsTr("Mode");						info: qsTr("Return median.")	}
			CheckBox { name: "median";			label: qsTr("Median");						info: qsTr("Return mode.")	}
			CheckBox { name: "mean";			label: qsTr("Mean");	checked: true;		info: qsTr("Return mean.")	}
		}

		Group
		{
			title:	qsTr("Distribution")

			CheckBox { name: "skewness";			label: qsTr("Skewness");			info: qsTr("Return skewness.")			}
			CheckBox { name: "kurtosis";			label: qsTr("Kurtosis");			info: qsTr("Return kurtosis.")			}
			CheckBox { name: "shapiroWilkTest";		label: qsTr("Shapiro-Wilk test");	info: qsTr("Shapiro-Wilk test of normality.")		}
			CheckBox { name: "sum";					label: qsTr("Sum");					info: qsTr("Return the sum of all values.")		}
		}

		Group
		{
			title:				qsTr("Dispersion")
			columns:			2
			Layout.columnSpan:	2

			CheckBox { name: "seMean";						label: qsTr("S.E. mean");							info: qsTr("Return standard error of the mean.")						}
			CheckBox { name: "sd";							label: qsTr("Std. deviation");		checked: true;	info: qsTr("Return standard deviation with Bessel's correction.")		}
			CheckBox { name: "coefficientOfVariation";		label: qsTr("Coefficient of variation");			info: qsTr("Return coefficient of variation.")							}
			CheckBox { name: "mad";							label: qsTr("MAD");									info: qsTr("Return mean absolute deviation (MAD) from median.")			}
			CheckBox { name: "madRobust";					label: qsTr("MAD robust");							info: qsTr("Return mean absolute deviation (MAD) from median, scaled with a constant 1.4826 to ensure consistency with standard deviation assuming normality.")}
			CheckBox { name: "iqr";							label: qsTr("IQR");									info: qsTr("Return inter-quartile range (IQR).")						}
			CheckBox { name: "variance";					label: qsTr("Variance");							info: qsTr("Return variance with Bessel's correction.")					}
			CheckBox { name: "range";						label: qsTr("Range");								info: qsTr("Return range (maximum-minimum).")							}
			CheckBox { name: "minimum";						label: qsTr("Minimum");				checked: true;	info: qsTr("Return minimum.")											}
			CheckBox { name: "maximum";						label: qsTr("Maximum");				checked: true;	info: qsTr("Return maximum.")											}
		}

		CheckBox { name: "statisticsValuesAreGroupMidpoints"; label: qsTr("Values are group midpoints"); debug: true }
	}

	Section
	{
		title: qsTr("Basic plots")
		columns: 2

		Group
		{
			Group
			{
				columns: 2
				CheckBox {	name: "distributionPlots";	label: qsTr("Distribution plots");	id:	distributionPlots;	info: qsTr("If selected, distribution plots are shown.")		}
				CheckBox {	name: "correlationPlots";	label: qsTr("Correlation plots");	id:	correlationPlots;	info: qsTr("If selected, correlation plots are shown.")			}
			}

			Group
			{
				enabled: distributionPlots.checked || correlationPlots.checked

				indent:		true
				CheckBox {	name: "distributionAndCorrelationPlotDensity";		label: qsTr("Display density");		info: qsTr("Display density in distribution and correlation plots.")				}
				CheckBox {	name: "distributionAndCorrelationPlotRugMarks";		label: qsTr("Display rug marks");	info: qsTr("Display rug marks along the x-axis in distribution and correlation plots.")					}
				DropDown {
					name: 	"distributionAndCorrelationPlotHistogramBinWidthType"
					label: 	qsTr("Bin width type")
					info:	qsTr("Select method for determining the number of bins in a histogram.")
					indexDefaultValue: 0
					values:
						[
						{label: qsTr("Sturges"),				value: "sturges"},
						{label: qsTr("Scott"),					value: "scott"},
						{label: qsTr("Doane"),					value: "doane"},
						{label: qsTr("Freedman-Diaconis"),		value: "fd"	},
						{label: qsTr("Manual"),					value: "manual"	}
					]
					id: binWidthType
				}
				DoubleField
				{
					name:			"distributionAndCorrelationPlotHistogramManualNumberOfBins"
					info:			qsTr("Specify the number of bins if manual method is selected.")
					label:			qsTr("Number of bins")
					defaultValue:	30
					min:			3;
					max:			10000;
					enabled:		binWidthType.currentValue === "manual"
				}
			}
		}

		Group
		{
			CheckBox {				name: "intervalPlot";	label: qsTr("Interval plots");	info: qsTr("Display interval plots.")					}
			CheckBox {				name: "qqPlot";			label: qsTr("Q-Q plots");		info: qsTr("Display Q-Q plots.")						}
			CheckBox {				name: "pieChart";		label: qsTr("Pie charts");		info: qsTr("Display pie charts.")						}
			CheckBox {				name: "dotPlot";		label: qsTr("Dot plots");		info: qsTr("Display dot plots.")							}
		}	
		
		Group
		{
			title: qsTr("Categorical plots")
			
			CheckBox 
			{			
				name: 		"paretoPlot"
				label: 		qsTr("Pareto plots")
				info:		qsTr("Display Pareto plots.")
				
				CheckBox 
				{			
					name: 				"paretoPlotRule"	
					label: 				qsTr("Pareto rule")
					info:				qsTr("Display Pareto rule in Pareto plots.")
					childrenOnSameRow: 	true
					
					CIField { name: 	"paretoPlotRuleCi";	info: qsTr("Confidence level for the Pareto plots.") }
				}
			}
			
			CheckBox 
			{	
				name: 		"likertPlot"
				label: 		qsTr("Likert plots")	
				info:		qsTr("Display likert plots")

				CheckBox 
				{			
					name: 				"likertPlotAssumeVariablesSameLevel"	
					label: 				qsTr("Assume all variables share the same levels")
					info:				qsTr("Assume all variables share the same levels. If selected, all variables are displayed in single plot with their levels merged into one group. If not selected, each variable is displayed in a separate plot.")
					childrenOnSameRow: 	true
				}				
				
				DropDown 
				{
					id: 				likertPlotAdjustableFontSize
					name: 				"likertPlotAdjustableFontSize"
					label: 				qsTr("Adjustable font size for vertical axis")
					info:				qsTr("Select font size for the likert plots.")
					indexDefaultValue: 	0
					values:
					[
						{label: qsTr("Normal"), 	value: "normal"},
						{label: qsTr("Small"),		value: "small"},
						{label: qsTr("Medium"),		value: "medium"},
						{label: qsTr("Large"),		value: "large"}
					]
				}
			}
		}
	}


	Section
	{
		title: qsTr("Customizable plots")
		columns: 1

		DropDown
		{
			name: 	"colorPalette"
			label: 	qsTr("Color palette")
			info:	qsTr("Select color palette for customizable plots.")
			indexDefaultValue: 0
			values:
			[
				{ label: qsTr("Colorblind"),		value: "colorblind"		},
				{ label: qsTr("Colorblind Alt."),	value: "colorblind3"	},
				{ label: qsTr("Viridis"),			value: "viridis"		},
				{ label: qsTr("ggplot2"),			value: "ggplot2"		},
				{ label: qsTr("Gray"),				value: "gray"			}
			]
		}

		CheckBox
		{
			name: 	"boxPlot";
			label: 	qsTr("Boxplots")
			info:	qsTr("Display boxplots")
			Group {
				columns: 2
				Group {
					CheckBox {	name: "boxPlotBoxPlot";			label: qsTr("Boxplot element"); checked: true;	info: qsTr("If selected, boxplots will contain the boxplot element.")	}
					CheckBox {	name: "boxPlotViolin";			label: qsTr("Violin element");					info: qsTr("If selected, boxplots will contain the violin element.")	}
					CheckBox {	name: "boxPlotJitter";			label: qsTr("Jitter element");					info: qsTr("If selected, boxplots will contain the jitter element.")	}
				}
				Group {
					CheckBox {  name: "boxPlotColourPalette";		label: qsTr("Use color palette");			info: qsTr("If selected, boxplots will use the specified custom color palette.")		}
					CheckBox {	name: "boxPlotOutlierLabel";		label: qsTr("Label outliers");				info: qsTr("If selected, outliers in the boxplots will be labelled")					}
				}
			}
		}


		CheckBox
		{
			name: 		"scatterPlot"
			label: 		qsTr("Scatter plots")
			info:		qsTr("Display scatter plots")
			columns:	2
			RadioButtonGroup
			{
				name:	"scatterPlotGraphTypeAbove";
				title:	qsTr("Graph above scatter plot")
				info:	qsTr("Select the type of graph shown above the scatter plot.")
				RadioButton { value: "density";		label: qsTr("Density");		checked: true;	info: qsTr("Density estimate is shown.")	}
				RadioButton { value: "histogram";	label: qsTr("Histogram");					info: qsTr("Histogram is shown.")			}
				RadioButton { value: "none";		label: qsTr("None");						info: qsTr("No plot is shown")				}
			}
			RadioButtonGroup
			{
				name:	"scatterPlotGraphTypeRight";
				title:	qsTr("Graph right to scatter plot")
				info:	qsTr("Select the type of graph shown right to the scatter plot.")
				RadioButton { value: "density";		label: qsTr("Density");		checked: true;	info: qsTr("Density estimate is shown.")	}
				RadioButton { value: "histogram";	label: qsTr("Histogram");					info: qsTr("Histogram is shown.")			}
				RadioButton { value: "none";		label: qsTr("None");						info: qsTr("No plot is shown")				}
			}
			CheckBox
			{
				name: 	"scatterPlotRegressionLine"
				label:	qsTr("Add regression line")
				info:	qsTr("Add regression line to the scatter plot.")
				checked: true
				RadioButtonGroup
				{
					name:	"scatterPlotRegressionLineType";
					info:	qsTr("Select the type of regression line in the scatter plot.")
					RadioButton { value: "smooth";	label: qsTr("Smooth");	checked: true;	info: qsTr("If less than a 1,000 data points, local polynomial regression line is fitted through the data. Otherwise a generalized additive model is fitted through the data.")	}
					RadioButton { value: "linear";	label: qsTr("Linear");					info: qsTr("Linear regression line is fitted through the data.")					}
				}

				CheckBox
				{
					name: 				"scatterPlotRegressionLineCi"
					label: 				qsTr("Show confidence interval")
					info:				qsTr("Add confidence interval around the regression line.")
					checked:			true
					childrenOnSameRow:	true
					CIField {	name: "scatterPlotRegressionLineCiLevel";	info: qsTr("Confidence level of the regression line confidence interval.") }
				}
			}
			CheckBox
			{
				enabled: splitBy.count > 0
				name:	"scatterPlotLegend"
				label:	qsTr("Show legend")
				info:	qsTr("Add legend to the scatter plot.")
				checked: true
			}
		}
			
		Group
		{
			
			VariablesForm
			{
				preferredHeight: 100 * preferencesModel.uiScale
				
				AvailableVariablesList 
				{ 
					name: 				"densityPlotVariables"
					label: 				qsTr("Density plots")
					source: 			[{ name: "allVariablesList", discard: ["variables", "splitby"], use: "type=ordinal|nominal|nominalText"}]
				}
				
				AssignedVariablesList 
				{ 
					name: 				"densityPlotSeparate"
					singleVariable: 	true
					title: 				qsTr("Separate densities:")
					suggestedColumns: 	["ordinal", "nominal"] 
				}
			}
			
			CheckBox 
			{ 
				name: 		"densityPlot"
				label: 		qsTr("Display density plots") 
				info:		qsTr("Display density plots.")
			
				DoubleField
				{
					name:			"densityPlotTransparency"
					label:			qsTr("Transparency")
					info:			qsTr("Select transparency level (between 0 and 100) of the density elements.")
					fieldWidth:		32
					defaultValue:	20
					min:			0
					max:			100
				}
			}
		}

		VariablesForm
		{
			preferredHeight: 100 * preferencesModel.uiScale
			AvailableVariablesList
			{
				name: "heatMapVariables"
				label: qsTr("Tile heatmaps for selected variables")
				source: [{ name: "allVariablesList", discard: ["variables", "splitby"], use: "type=ordinal|nominal|nominalText"}]
			}
			AssignedVariablesList
			{
				name: "heatmapHorizontalAxis"
				label: qsTr("Horizontal axis:")
				singleVariable: true
				info:	qsTr("Select variable for the horizontal axis of the heatmap plots.")
			}
			AssignedVariablesList
			{
				name: "heatmapVerticalAxis"
				label: qsTr("Vertical axis:")
				singleVariable: true
				info:	qsTr("Select variable for the vertical axis of the heatmap plots.")
			}
		}

		Group
		{
			indent: true
			CheckBox { name: "heatmapLegend"; label: qsTr("Display legend");	info: qsTr("Display legend for the heatmap plots.")	}
			CheckBox
			{
				name: "heatmapDisplayValue"; label: qsTr("Display value"); childrenOnSameRow: false;
				info: qsTr("Display value inside of each tile of the heatmap plot.")
				DoubleField { name: "heatmapDisplayValueRelativeTextSize"; label: qsTr("Relative text size"); negativeValues: false; defaultValue: 1; info: qsTr("Select the font size of the tile values in the heatmap plots.") }
			}
			DoubleField { name: "heatmapTileWidthHeightRatio"; label: qsTr("Width to height ratio of tiles"); negativeValues: false; defaultValue: 1; info: qsTr("Adjust the ratio of width to height of the tiles in the heatmap plot. By default it is set to 1 which results in square tiles.")}

			Group
			{
				columns: 2
				title: qsTr("Statistic to plot")
				RadioButtonGroup
				{
					name: 	"heatmapStatisticContinuous"
					title:	qsTr("For scale variables")
					info:	qsTr("Select what values of selected continuous variables are supposed to be as the basis for the heatmap plots.")
					RadioButton { value: "mean";		label: qsTr("Mean");	checked: true;	info: qsTr("The mean (excluding missing values) is calculated from the values for each tile.") 													}
					RadioButton { value: "median";		label: qsTr("Median");					info: qsTr("The median (excluding missing values) is calculated from the values for each tile.")												}
					RadioButton { value: "identity";	label: qsTr("Value itself");			info: qsTr("The value of the variable is drawn in each tile. This option works only if every tile in the plot has only zero or one values.") 	}
					RadioButton { value: "length";		label: qsTr("Number of observations");	info: qsTr("The number of valid (i.e., non-missing) observations is calculated for each tile.") 												}
				}

				RadioButtonGroup
				{
					name: 	"heatmapStatisticDiscrete"
					title:	qsTr("For nominal and ordinal variables")
					info:	qsTr("Select what values of selected continuous variables are supposed to be as the basis for the heatmap plots.")
					RadioButton { value: "mode";		label: qsTr("Mode");	checked: true;	info: qsTr("The mode (excluding missing values) is calculated from the values for each tile.") 													}
					RadioButton { value: "identity";	label: qsTr("Value itself");			info: qsTr("The value of the variable is drawn in each tile. This option works only if every tile in the plot has only zero or one values.")	}
					RadioButton { value: "length";		label: qsTr("Number of observations");	info: qsTr("The number of valid (i.e., non-missing) observations is calculated for each tile.") 												}
				}
			}
		}
	}

	Section
	{
		title: qsTr("Tables")

		CheckBox
		{
			name:			"frequencyTables"
			label:			qsTr("Frequency tables")
			info:			qsTr("Display frequency tables.")
			IntegerField
			{
				name:			"frequencyTablesMaximumDistinctValues"
				label:			qsTr("Maximum distinct values")
				info:			qsTr("Select the maximum of distinct values to show in the frequency tables.")
				min:			1
				defaultValue:	10
				fieldWidth:		50
				max:			2e2
			}
		}
		CheckBox
		{
			name	: "stemAndLeaf";
			label	: qsTr("Stem and leaf tables")
			info:	: qsTr("Display stem and leaf tables.")
			DoubleField
			{
				name: "stemAndLeafScale";	label: qsTr("scale");	negativeValues: false;	inclusive: JASP.MaxOnly;	max: 200;	defaultValue: 1.0;
				info: qsTr("The scale parameter controls how much the table is expanded. For example, scale = 2 will cause the table to be roughly twice as long as the default (scale = 1).")
			}
		}

	}

	Section
	{
		title: qsTr("Charts")
		debug: true

		RadioButtonGroup
		{
			name:	"chartType";
			title:	qsTr("Chart Type")

			RadioButton { value: "_1noCharts";		label: qsTr("None")			}
			RadioButton { value: "_2barCharts";		label: qsTr("Bar charts")	}
			RadioButton { value: "_3pieCharts";		label: qsTr("Pie charts")	}
			RadioButton { value: "_4histograms";	label: qsTr("Histograms")	}
		}

		RadioButtonGroup
		{
			name:	"chartValues"
			title:	qsTr("Chart Values")

			RadioButton { value: "_1frequencies";	label: qsTr("Frequencies")	}
			RadioButton { value: "_2percentages";	label: qsTr("Percentages")	}
		}
	}
}
