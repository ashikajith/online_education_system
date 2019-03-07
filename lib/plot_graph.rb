module PlotGraph
  class Graphs
    X_AXIS_RANGE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    def self.column name, data, xtext, ytext
      graph = LazyHighCharts::HighChart.new('column') do |f|
        f.series(:name=>name, showInLegend: false, :data=> data, color:'#44BBFF') 
        f.options[:chart][:defaultSeriesType] = "column"
        f.plot_options(series: { pointWidth: 20})
        f.yAxis [{ gridLineWidth: 0, max:100, minorGridLineWidth: 0, :title => {:text =>ytext}}]
        f.xAxis [{:title => {:text => xtext}, categories: X_AXIS_RANGE}]
      end
      return graph
    end

    def self.percentage name, data, color, height=400, xtext, ytext
      graph = LazyHighCharts::HighChart.new('column') do |f|
        name.count.times do |count|
          f.series(:name=>name[count], :data=> data[count], color:color[count])
        end
        f.options[:legend] = {:layout => "horizontal", :style => "class:well" }
        f.options[:chart][:defaultSeriesType] = "column"
        f.options[:chart][:height] = height
        f.plot_options({:column=>{:stacking=>"percent", pointWidth: 20}})
        f.yAxis [{ gridLineWidth: 0, minorGridLineWidth: 0, :title => {:text =>ytext}}]
        f.xAxis [{:title => {:text => xtext}, categories:X_AXIS_RANGE}]
      end
      return graph
    end

    def self.bar name_1, name_2, data_1, data_2, xtext, ytext
      graph = LazyHighCharts::HighChart.new('column') do |f|
        f.series(:name=>name_1, :data=> data_1, color:'#44BBFF') 
        f.series(:name=>name_2, :data=> data_2)
        f.yAxis [{ gridLineWidth: 0, minorGridLineWidth: 0, :title => {:text => ytext}}]
        f.xAxis [{:title => {:text => xtext}, tickInterval:1, categories:X_AXIS_RANGE}]
      end
      return graph
    end

    def self.horizontal_bar name, data, color, width=100, height=50
      graph = LazyHighCharts::HighChart.new('column') do |f|
        data.count.times do |count|
          f.series(:name=>name[count], showInLegend: false, :data=> data[count], color:color[count], borderColor: '#44BBFF', pointWidth: 20)
        end
        f.options[:chart][:defaultSeriesType] = "bar"
        f.options[:chart][:height] = height
        f.options[:chart][:width] = width
        f.plot_options({:bar=>{:stacking=>"percent" , pointWidth: 20 }})
        f.yAxis [{ gridLineWidth: 0, minorGridLineWidth: 0, :title => {:text => ""}, labels: { enabled: false }}]
        f.xAxis [{gridLineWidth: 0, minorGridLineWidth: 0,:title => {:text => ""}, labels: { enabled: false }}]
      end
      return graph
    end
  end
end