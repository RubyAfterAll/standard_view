# frozen_string_literal: true

module StandardView
  module ApplicationHelper
    def action
      ActiveSupport::StringInquirer.new action_name
    end

    def actionable_name
      return "new" if action_name == "create"
      return "edit" if action_name == "update"

      action_name
    end

    def active_for(**options)
      "active" if on_page?(options)
    end

    def on_page?(check_parameters: false, **options)
      current_page?(options, check_parameters: check_parameters)
    rescue ActionController::UrlGenerationError
      false
    end

    def icon_for(reference, spin: false)
      reference = reference.icon if reference.respond_to?(:icon)
      definition = icon_definition_for_reference(reference)
      icon_tag(definition[:name], definition[:style], spin: spin)
    end

    def icon_definition_for_reference(reference)
      definition = reference.to_h if reference.respond_to?(:to_h)
      definition ||= I18n.t("icons.#{reference}", default: nil) || reference if reference.present?
      definition ||= {}
      definition = { name: definition } if definition.present? && !definition.respond_to?(:fetch)
      definition
    end

    def current_page
      params[:page]
    end

    def icon_tag(name = nil, style = nil, spin: false)
      content_tag(:i, "", class: "fa#{style || "s"} fa-#{name || "question"} #{"fa-spin" if spin}")
    end

    def link_to_destroy_with_confirmation_for_record(record, extra_classes: "")
      link_to t("common.destroy"),
              record,
              class: "btn btn-danger #{extra_classes}",
              method: :delete,
              data: { confirm: t("common.confirm_destroy") }
    end
  end
end
