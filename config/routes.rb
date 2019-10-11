Rails.application.routes.draw do
  get '', to: redirect("ie_enrollment/start")
  get 'ie_enrollment/start'
  post 'ie_enrollment/enroll'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
