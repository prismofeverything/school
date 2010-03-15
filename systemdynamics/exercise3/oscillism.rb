module Oscillism
  @@infinity = 1.0/0.0

  class Oscillatom
    def initialize(name, level)
      @name = name
      @level = level
      @process = Proc.new { 0.0 }
    end

    def name
      @name
    end

    def level
      @level
    end

    def define(&block)
      @process = block
    end
  end

  class Stock < Oscillatom
    def initialize(name, level)
      super(name, level)
      @pending = 0.0
      @from = []
      @to = []
    end

    def flow_to(flow)
      @to << flow
    end

    def flow_from(flow)
      @from << flow
    end

    def discern
      @pending += @from.inject(0) {|total, from| total + from.level}
      @pending -= @to.inject(0) {|total, to| total + to.level}
      @pending += @process.call
      @pending
    end

    def step
      @level += @pending
      @pending = 0
      @level
    end
  end

  class Flow < Oscillatom
    def initialize(name, a, b)
      super(name, 0)
      @terminals = [a, b]
      a.flow_to(self)
      b.flow_from(self)
    end

    def step
      @level = @process.call
    end
  end

  class Parameter < Oscillatom
    def initialize(name, level)
      super(name, level)
      @process = Proc.new {|level| level}
    end

    def assign(level)
      @level = level
    end

    def level
      @process.call(@level)
    end
  end

  class HistoryIdentity
    def initialize(name)
      @name = name
      self.clear
    end

    def clear
      @history = []
      @min = 111111111.1
      @max = -111111111.1
      @x_lens = Proc.new {|x| x}
      @y_lens = Proc.new {|y| y}
    end

    def snapshot(level)
      if level and not (level.nan? or level.infinite?)
        @history << level
        @min = level if @min > level
        @max = level if @max < level
      end
    end

    def x_bounds
      [0.0, @history.size.to_f]
    end

    def y_bounds
      [@min, @max]
    end

    def bound
      @x_lens = History.forge_lens(self.x_bounds)
      @y_lens = History.forge_lens(self.y_bounds)
    end

    def render_to_field(render, color, x, y, width, height)
      self.bound

      apoint = nil
      bpoint = V2D[0.0, 0.0]
      @history.each_with_index do |point, t|
        localx = x + (@x_lens[t] * width)
        localy = y + (@y_lens[point] * height)

        bpoint.xy = [localx, localy]
        if apoint
          begin
            render.add(Line[:points, [apoint, bpoint]], Style[:stroke, color, :strokewidth, 3.0])
          rescue
            puts "had trouble rendering #{[[apoint.x, apoint.y], [bpoint.x, bpoint.y]].inspect}"
          end
        else
          apoint = V2D[0.0, 0.0]
        end
        apoint.xy = bpoint
      end
    end
  end

  class History
    def initialize
      @history = {}
    end

    def history(name)
      @history[name]
    end

    def register(name)
      @history[name] = HistoryIdentity.new(name)
    end

    def snapshot(name, level)
      self.history(name).snapshot(level)
    end

    def clear
      @history.keys.each do |key|
        self.history(key).clear
      end
    end

    def self.forge_lens(bounds)
      width = bounds[1] - bounds[0]
      offset = bounds[0]

      Proc.new do |raw|
        (raw - offset) / width
      end
    end

    def render_to_field(name, render, color, x, y, w, h)
      self.history(name).render_to_field(render, color, x, y, w, h)
    end
  end

  class Model
    def initialize
      @time_step = 0
      @stocks = {}
      @flows = {}
      @parameters = {}
      @atoms = []
      @parameter_order = []
      @history = History.new
    end

    def time_step
      @time_step
    end

    def history
      @history
    end

    def clear
      @time_step = 0
      @history.clear
    end

    def stock(name)
      @stocks[name]
    end

    def flow(name)
      @flows[name]
    end

    def parameter(name)
      @parameters[name]
    end

    def atoms
      @atoms
    end

    def atom(name)
      return @stocks[name] if @stocks.keys.include?(name)
      return @flows[name] if @flows.keys.include?(name)
      return @parameterss[name] if @parameters.keys.include?(name)
    end

    def names
      atoms.map {|atom| atom.name}
    end

    def add_stock(name, level)
      stock = Stock.new(name, level)
      @stocks[stock.name] = stock
      @history.register(stock.name)
      @atoms << stock
      stock
    end

    def add_flow(name, a, b)
      flow = Flow.new(name, a, b)
      @flows[flow.name] = flow
      @history.register(flow.name)
      @atoms << flow
      flow
    end

    def add_parameter(name, level)
      parameter = Parameter.new(name, level)
      @parameters[parameter.name] = parameter
      @parameter_order << parameter
      @atoms << parameter
      parameter
    end

    def parameter_vector
      @parameter_order.map {|parameter| parameter.level}
    end

    def assign_parameters(vector)
      vector.zip(@parameter_order).each do |pair|
        level, parameter = pair
        parameter.assign(level)
      end
    end

    def step
      @time_step += 1

      @flows.values.each do |flow|
        flow.step
        @history.snapshot(flow.name, flow.level)
      end

      @stocks.values.each do |stock|
        stock.discern
      end

      @stocks.values.each do |stock|
        stock.step
        @history.snapshot(stock.name, stock.level)
      end
    end

    def run(time_steps)
      self.clear

      (0..time_steps).each do |step|
        self.step
      end
    end
  end
end

