define :pip_install do
  script params[:name] do
    not_if "pip list | grep #{name}"
    interpreter 'bash'
    code <<-EOC
      pip install #{name}
    EOC
  end
end
