json.array!(@todos) do |todo|
  json.extract! todo, :id, :beginDate, :endDate, :priority, :description, :status
  json.url todo_url(todo, format: :json)
end
