require 'rubygems'
require 'xrvg'
include XRVG

require 'oscillism'

class Chemotaxis
  def initialize(cell_width)
    @model = Oscillism::Model.new

    @active_cheW = Oscillism::Stock.new('active cheW', 0.0)
    @methylated_cheW = Oscillism::Stock.new('methylated cheW', 0.0)
    @phosphorylated_cheB = Oscillism::Stock.new('phosphorylated cheB', 0.0)
    @phosphorylated_cheY = Oscillism::Stock.new('phosphorylated cheY', 0.0)
    @exogenous = Oscillism::Stock.new('exogenous', 0.0)

    @activation = Oscillism::Flow.new('activation', @exogenous, @active_cheW)
    @deactivation = Oscillism::Flow.new('deactivation', @active_cheW, @exogenous)
    @methylation = Oscillism::Flow.new('methylation', @exogenous, @methylated_cheW)
    @demethylation = Oscillism::Flow.new('demethylation', @methylated_cheW, @exogenous)
    @cheB_phosphorylation = Oscillism::Flow.new('cheB_phosphorylation', @exogenous, @phosphorylated_cheB)
    @cheB_dephosphorylation = Oscillism::Flow.new('cheB_dephosphorylation', @phosphorylated_cheB, @exogenous)
    @cheY_phosphorylation = Oscillism::Flow.new('cheY_phosphorylation', @exogenous, @phosphorylated_cheY)
    @cheY_dephosphorylation = Oscillism::Flow.new('cheY_dephosphorylation', @phosphorylated_cheY, @exogenous)

    @activation_factor = Oscillism::Parameter.new('activation factor', 0.1)
    @deactivation_factor = Oscillism::Parameter.new('deactivation factor', 0.01)
    @methylation_factor = Oscillism::Parameter.new('methylation factor', 0.001)
    @demethylation_factor = Oscillism::Parameter.new('demethylation factor', 0.01)
    @phosphorylation_factor = Oscillism::Parameter.new('phosphorylation factor', 0.1)
    @cheZ = Oscillism::Parameter.new('cheZ', 0.1)

    @activation.define { @methylated_cheW.level * @activation_factor.level }
    @deactivation.define { @deactivation_factor.level }
    @methylation.define { @methylation_factor.level }
    @demethylation.define { @phosphorylated_cheB.level * @demethylation_factor.level }
    @cheB_phosphorylation.define { @active_cheW.level * @phosphorylation_factor.level }
    @cheB_dephosphorylation.define { @cheZ.level }
    @cheY_phosphorylation.define { @active_cheW.level * @phosphorylation_factor.level }
    @cheY_dephosphorylation.define { @cheZ.level }

    @model.add_stock(@active_cheW)
    @model.add_stock(@methylated_cheW)
    @model.add_stock(@phosphorylated_cheB)
    @model.add_stock(@phosphorylated_cheY)

    @model.add_flow(@activation)
    @model.add_flow(@deactivation)
    @model.add_flow(@methylation)
    @model.add_flow(@demethylation)
    @model.add_flow(@cheB_phosphorylation)
    @model.add_flow(@cheB_dephosphorylation)
    @model.add_flow(@cheY_phosphorylation)
    @model.add_flow(@cheY_dephosphorylation)

    @model.add_parameter(@activation_factor)
    @model.add_parameter(@deactivation_factor)
    @model.add_parameter(@methylation_factor)
    @model.add_parameter(@demethylation_factor)
    @model.add_parameter(@phosphorylation_factor)
    @model.add_parameter(@cheZ)

    @cell_width = cell_width
    @buffer = cell_width / 6.0
  end

  def model
    @model
  end

  def run
    @model.run(100)
  end

  def iterate(steps, from, to, &block)
    width = to - from
    interval = width.to_f / steps

    unless interval == 0
      anchor = from
      index = 0
      while anchor < to
        yield anchor, index
        anchor += interval
        index += 1
      end
    end
  end

  def offset(index)
    (index * @cell_width) + (index * @buffer)
  end

  def render_parameter_range(render, name, steps, from, to, y)
    puts name
    parameter = @model.parameter(name)
    iterate(steps, from, to) do |anchor, index|
      parameter.assign(anchor)
      self.run
      self.render(render, offset(index), y)
    end
  end

  def render_parameter_matrix(render, a, b)
    puts a['name']
    aparameter = @model.parameter(a['name'])
    iterate(a['steps'], a['from'], a['to']) do |anchor, index|
      render_parameter_range(render, b['name'], b['steps'], b['from'], b['to'], offset(index))
    end
  end

  def render(r, x, y)
    puts "#{x}, #{y}"
    @model.history.render_to_field('active cheW', r, 'green', x, y, @cell_width, @cell_width)
    @model.history.render_to_field('methylated cheW', r, 'red', x, y, @cell_width, @cell_width)
    @model.history.render_to_field('phosphorylated cheB', r, 'blue', x, y, @cell_width, @cell_width)
  end

end

render = SVGRender[:filename, "chemotaxis.svg", :imagesize, "30cm"]

a = {
  'name' => 'activation factor',
  'steps' => 5,
  'from' => 0.1,
  'to' => 10.0
}

b = {
  'name' => 'demethylation factor',
  'steps' => 5,
  'from' => 0.001,
  'to' => 1.0
}

chemotaxis = Chemotaxis.new(100)
chemotaxis.render_parameter_matrix(render, a, b)

render.end



