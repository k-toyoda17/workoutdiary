json.array!(@tasks) do |task|
  json.title task.name
  json.start task.activity_at
  #json.end task.updated_at
  json.url task_url(task)
end