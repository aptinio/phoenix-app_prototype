defmodule AppPrototype.FormHelpers do
  alias Phoenix.HTML.{Form,Tag}

  def error_alert(changeset, content \\ "Oops, something went wrong! Please check the errors below.") do
    if changeset.action do
      Tag.content_tag(:div, content, class: "alert callout", role: "alert")
    end
  end

  def input(form, field, opts \\ []) do
    {input_type, opts} = Keyword.pop(opts, :as, input_type(form, field, opts))
    input(input_type, form, field, opts)
  end

  defp input_type(form, field, opts) do
    cond do
      opts[:rows] -> :textarea
      opts[:options] -> :select
      true -> Form.input_type(form, field)
    end
  end

  defp input(:select, form, field, opts) do
    wrap(form, field, opts, &select(&1, &2, &3))
  end

  defp input(input_type, form, field, opts) do
    wrap(form, field, opts, &(apply(Form, input_type, [&1, &2, &3])))
  end

  defp wrap(form, field, opts, callback) do
    label_opts = []
    {label, input_opts} = Keyword.pop(opts, :label, Form.humanize(field))

    if form.errors[field] do
      label_opts = Keyword.put(label_opts, :class, "is-invalid-label")
      input_opts = Keyword.put(input_opts, :class, "is-invalid-input")
    end

    Tag.content_tag(:label, label_opts) do
      Enum.filter([
        label,
        callback.(form, field, input_opts),
        AppPrototype.ErrorHelpers.error_tag(form, field)
      ], &(&1))
    end
  end

  defp select(form, field, opts) do
    {options, opts} = Keyword.pop(opts, :options, [])
    Form.select(form, field, options, opts)
  end
end
