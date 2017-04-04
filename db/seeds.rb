for i in 1..25
  User.create(
    email: "user#{i}@example.com", password: "12345678", name: "Name #{i}",
    location: "City #{i}", description: "Blah blah"
  ).confirm
end
