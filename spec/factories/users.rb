FactoryBot.define do
    factory :user do
      fio { "Учитель1" }
      email { "email_teacher1@mail.ru" }
      password { 'password1' }
      teacher { true }
    end
  end
