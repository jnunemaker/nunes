require "bundler/setup"
require "nunes/tracer"
require "securerandom"

# tracer = Nunes::Tracer.new
# tracer.trace(SecureRandom.hex(30)) do |root|
#   tracer.span("middleware", tags: {component: "Authentication"}) do
#     tracer.span("memcached", tags: {key: "users/1"}) do

#     end
#     tracer.span("mysql", tags: {table: "users", verb: "select"}) do
#       # get user
#     end
#   end

#   tracer.span("action_controller", tags: {controller: "UsersController", action: "show"}) do
#     tracer.span("before_filter") do

#     end
#     tracer.span("issues_repository") do
#       tracer.span("active_record", tags: {model: "Issues"}) do
#         tracer.span("mysql", tags: {table: "issues", verb: "select"}) do
#           # get issues
#         end
#       end
#     end
#   end
#   pp root.descendants.map(&:name)
#   pp root.descendants.map(&:tags)
# end
