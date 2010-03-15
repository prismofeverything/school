require 'rubygems'
require 'xrvg'
include XRVG

require 'oscillism'

class Chemotaxis
  def initialize(cell_width)
    @model = Oscillism::Model.new

    @active_cheW = @model.add_stock(Oscillism::Stock.new('active cheW', 10.0))
    @methylated_cheW = @model.add_stock(Oscillism::Stock.new('methylated cheW', 10.0))
    @phosphorylated_cheB = @model.add_stock(Oscillism::Stock.new('phosphorylated cheB', 10.0))
    @exogenous = Oscillism::Stock.new('exogenous', 0.0)

    @activation = @model.add_flow(Oscillism::Flow.new('activation', @exogenous, @active_cheW))
    @deactivation = @model.add_flow(Oscillism::Flow.new('deactivation', @active_cheW, @exogenous))
    @methylation = @model.add_flow(Oscillism::Flow.new('methylation', @exogenous, @methylated_cheW))
    @demethylation = @model.add_flow(Oscillism::Flow.new('demethylation', @methylated_cheW, @exogenous))
    @cheB_phosphorylation = @model.add_flow(Oscillism::Flow.new('cheB phosphorylation', @exogenous, @phosphorylated_cheB))
    @cheB_dephosphorylation = @model.add_flow(Oscillism::Flow.new('cheB dephosphorylation', @phosphorylated_cheB, @exogenous))

    @gradient = @model.add_parameter(Oscillism::Parameter.new('gradient', 0.0))
    @activation_factor = @model.add_parameter(Oscillism::Parameter.new('activation factor', 20.0))
    @deactivation_factor = @model.add_parameter(Oscillism::Parameter.new('deactivation factor', 0.1))
    @demethylation_factor = @model.add_parameter(Oscillism::Parameter.new('demethylation factor', 0.002))
    @phosphorylation_factor = @model.add_parameter(Oscillism::Parameter.new('phosphorylation factor', 1.0))
    @cheR = @model.add_parameter(Oscillism::Parameter.new('cheR', 1.1))
    @cheZ = @model.add_parameter(Oscillism::Parameter.new('cheZ', 0.1))

    @activation.define { (@methylated_cheW.level - @gradient.level) * @activation_factor.level / @active_cheW.level}
    @deactivation.define { @deactivation_factor.level * @active_cheW.level }
    @methylation.define { @cheR.level / @methylated_cheW.level }
    @demethylation.define { @phosphorylated_cheB.level * @demethylation_factor.level * @methylated_cheW.level }
    @cheB_phosphorylation.define { @active_cheW.level * @phosphorylation_factor.level / @phosphorylated_cheB.level }
    @cheB_dephosphorylation.define { @cheZ.level * @phosphorylated_cheB.level }
    @gradient.define { @model.time_step > 42 ? 1.0 : 0.0 }

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
  'name' => 'phosphorylation factor',
  'steps' => 5,
  'from' => 0.01,
  'to' => 1.0
}

b = {
  'name' => 'cheR',
  'steps' => 5,
  'from' => 0.1,
  'to' => 50.0
}

chemotaxis = Chemotaxis.new(100)
chemotaxis.render_parameter_matrix(render, a, b)

render.end



