
macro match(x, hash)
	{% terminated = false %}
	case {{x}}
		{% for key, value in hash %}
			{% if !terminated %}
				{% if key.stringify == "_" %}
					else
					{% terminated = true %}
				{% else %}
					when {{key}}
				{% end %}
				{{value}}
			{% end %}
		{% end %}
	end
end
