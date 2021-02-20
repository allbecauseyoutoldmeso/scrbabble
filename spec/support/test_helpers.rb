module TestHelpers
  def log_in(user)
    visit(new_session_path)
    fill_in('name', with: user.name)
    fill_in('password', with: user.password)
    click_button('log in')
  end
end
