
macro match(x, hash)
	{% terminated = false %}
	case {{x}}
		{% for key, value in hash %}
			{% if !terminated %}
				{% if key.stringify == "_" %}
					{%  %}
					else
					{% terminated = true %}
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
