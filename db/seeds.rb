User.create!(name:  "管理ユーザー",
             email: "adminuser@example.com",
             admin: true,
             password: "password",
             password_confirmation: "password")

20.times do |n|
  name  = Faker::Name.name
  email = "genuser-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end