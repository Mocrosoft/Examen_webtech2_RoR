class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
      @db = CouchRest.database(ENV['DB'])
      @json_text = {'beginDate' => '20/01/2016', 'endDate' => '25/01/2016', 'priority' => '3', 'description' => 'Walk my dog', 'status' => 'not completed'}
	    @response = @db.save_doc(@json_text)    
	    @todo = Todo.new(beginDate: @json_text['beginDate'], endDate: @json_text['endDate'], priority: @json_text['priority'].to_i, description: @json_text['description'], status: @json_text['status'])
      if @todo.save
        @message = "sqlite3 data successfully inserted."
      end
      @todo_all = []
      @id_to_view = params[:id]
      @result = @db.view('_design/todo/_view/todo_all')['rows']
      @result.each do |todo|
        #puts "@@@@@@@@@@@@@@@@@@@éé = #{params[:id]} = #{todo['value']['priority']}"
        if params.has_key?(:id) then
          if (params[:id] == todo['value']['priority'])
            @todo_all.push(todo['value'])
          end
        else
          @todo_all.push(todo['value'])
        end
      end
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:beginDate, :endDate, :priority, :description, :status)
    end
end
