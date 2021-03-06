require 'rubygems'
require 'xrvg'
include XRVG

require 'oscillism'

class Chemotaxis
  def initialize(cell_width)
    @model = Oscillism::Model.new

    @active_cheW = @model.add_stock('active cheW', 10.0)
    @methylated_cheW = @model.add_stock('methylated cheW', 10.0)
    @phosphorylated_cheB = @model.add_stock('phosphorylated cheB', 10.0)
    @exogenous = Oscillism::Stock.new('exogenous', 0.0)

    @activation = @model.add_flow('activation', @exogenous, @active_cheW)
    @deactivation = @model.add_flow('deactivation', @active_cheW, @exogenous)
    @methylation = @model.add_flow('methylation', @exogenous, @methylated_cheW)
    @demethylation = @model.add_flow('demethylation', @methylated_cheW, @exogenous)
    @cheB_phosphorylation = @model.add_flow('cheB phosphorylation', @exogenous, @phosphorylated_cheB)
    @cheB_dephosphorylation = @model.add_flow('cheB dephosphorylation', @phosphorylated_cheB, @exogenous)

    @gradient = @model.add_parameter('gradient', 0.0)
    @activation_factor = @model.add_parameter('activation factor', 20.0)
    @deactivation_factor = @model.add_parameter('deactivation factor', 0.1)
    @demethylation_factor = @model.add_parameter('demethylation factor', 0.00002)
    @phosphorylation_factor = @model.add_parameter('phosphorylation factor', 1.0)
    @cheR = @model.add_parameter('cheR', 20.1)
    @cheZ = @model.add_parameter('cheZ', 0.05)

    @activation.define { (@methylated_cheW.level - @gradient.level) * @activation_factor.level / @active_cheW.level}
    @deactivation.define { @deactivation_factor.level * @active_cheW.level }
    @methylation.define { @cheR.level / @methylated_cheW.level }
    @demethylation.define { @phosphorylated_cheB.level * @demethylation_factor.level * @methylated_cheW.level * @active_cheW.level }
    @cheB_phosphorylation.define { @active_cheW.level * @phosphorylation_factor.level / @phosphorylated_cheB.level }
    @cheB_dephosphorylation.define { @cheZ.level * @phosphorylated_cheB.level }
    @gradient.define { @model.time_step > 42 ? 25.0 : 0.0 }

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
      aparameter.assign(anchor)
      render_parameter_range(render, b['name'], b['steps'], b['from'], b['to'], -offset(index))
    end
  end

  def render(r, x, y)
    puts "#{x}, #{y}"
    @model.history.render_to_field('active cheW', r, 'red', x, y, @cell_width, @cell_width)
    @model.history.render_to_field('methylated cheW', r, 'green', x, y, @cell_width, @cell_width)
    @model.history.render_to_field('phosphorylated cheB', r, 'blue', x, y, @cell_width, @cell_width)
  end

end

render = SVGRender[:filename, "chemotaxis.svg", :imagesize, "20cm"]

a = {
  'name' => 'deactivation factor',
  'steps' => 5,
  'from' => 0.01,
  'to' => 0.05
}

b = {
  'name' => 'demethylation factor',
  'steps' => 5,
  'from' => 0.000005,
  'to' => 0.000025
}

chemotaxis = Chemotaxis.new(40)
chemotaxis.render_parameter_range(render, 'demethylation factor', 5, 0.000005, 0.00005, 0)
# chemotaxis.render_parameter_matrix(render, a, b)

# chemotaxis.run
# chemotaxis.render(render, 0, 0)

render.end



