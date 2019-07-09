#

macro match(x, hash)
	{% terminated = false %}
	case {{x}}
		{% for key, value in hash %}
			{% if !terminated %}
				{% if key.is_a?(Underscore) %}
					else
					{% terminated = true %}
				{% elsif key.is_a?(Or) %}
					{% count = key.stringify.split("||").size %}
					{% left = key.left %}
					when {{key.right}}{% for i in (0...count - 2) %},{{left.right}}{% left = left.left %}{% end %},{{left}}
				{% else %}
					when {{key}}
				{% end %}
				{% if value.is_a?(ProcLiteral) %}
					{{value.body}}
				{% else %}
					{{value}}
				{% end %}
			{% end %}
		{% end %}
	end
end
