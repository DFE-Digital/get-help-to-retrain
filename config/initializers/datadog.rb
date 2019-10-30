Datadog.configure do |c|
  # This will activate auto-instrumentation for Rails
  c.use :rails
  c.tracer hostname: 's108d01-ddagent.westeurope.azurecontainer.io'
end
