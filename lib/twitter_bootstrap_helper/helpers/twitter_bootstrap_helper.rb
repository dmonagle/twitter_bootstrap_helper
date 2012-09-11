module TwitterBootstrapHelper

  # Creates an "i" tag with the given +icon+ class.
  # * This also works with Font Awesome
  def tb_icon(icon, options = {})
    options = {
        class: ""
    }.merge(options)

    style = "color: #{options[:color]}" if options[:color]
    content_tag(:i, "", :class => "#{icon} #{options[:class]}", :style => style) unless icon.nil?
  end

  # This is a wrapper for the link_to helper
  # ==== Options
  # * <tt>:icon</tt> - Optionally display an icon before the name.
  # * All other options are passed through the the link_to helper.
  def tb_link(name, link="#", options = nil)
    options ||= {}

    icon = nil
    if options[:icon]
      icon = options[:icon]
      options.delete(:icon)
    end

    label = [].tap do |b|
      b << tb_icon(icon) unless icon.nil?
      b << name
    end.join.html_safe

    link_to(label, link, options)
  end

  # Creates a "button" tag. The class defaults to "btn" and the type defaults to :submit.
  # ==== Options
  # * <tt>:icon</tt> - Optionally display an icon on the button.
  # * <tt>:class</tt> - Specify a class for the button. Defaults to "btn".
  # * <tt>:type</tt> - Defaults to submit.
  # * All other options are passed through to the the content_tag helper.
  def tb_button(name, options = {})
    options = {
        class: "btn",
        icon: nil,
        type: :submit,
    }.merge(options || {})

    options = options.nil? ? default_options : default_options.merge(options)

    icon = nil
    if options[:icon]
      icon = options[:icon]
      options.delete(:icon)
    end

    button_label = [].tap do |b|
      b << tb_icon(icon)
      b << name
    end.join.html_safe

    content_tag(:button, button_label, options)
  end

  # Creates a badge containing the content "name"
  # ==== Options
  # * <tt>:class</tt> - Defaults to "badge", any other class specified will be appended to the "badge" class.
  def tb_badge(name, options = {})
    options ||= {}

    options[:class] = "badge #{options[:class]}"

    content_tag(:span, name, options)
  end

  # Creates a label containing the content "name"
  # ==== Options
  # * <tt>:class</tt> - Defaults to "label", any other class specified will be appended to the "label" class.
  def tb_label(name, options = {})
    options ||= {}

    options[:class] = "label #{options[:class]}"

    content_tag(:span, name, options)
  end

  # Creates an "li" tag formatted for a sidebar.
  # ==== Options
  # * <tt>:icon</tt> - Optionally display an icon.
  # * <tt>:badge</tt> - Defaults to 0. Badge is only displayed if the value is greater than 0
  # * <tt>:badge_class</tt> - Optional badge class to add. Eg "badge-success"
  # * <tt>:active</tt> - adds the active class showing the item is selected
  def tb_sidebar_link(name, link="#", options = {})
    options = {
        active: (request.fullpath == link)
    }.merge(options || {})

    icon = nil
    li_class = []
    i_class = []

    if options[:icon]
      icon = options[:icon]
      options.delete(:icon)
    end

    if options[:active]
      li_class << "active"
      i_class << "icon-white"
      options.delete(:active)
    end

    i_class << icon
    badge = (options[:badge] || 0) > 0 ? " #{tb_badge(options[:badge], :class => "pull-right #{options[:badge_class]}")}".html_safe : ""
    icon_tag = content_tag(:i, "", :class => i_class.join(" "))
    content_tag(:li, link_to(icon_tag + name + badge, link, options), :class => li_class.empty? ? nil : li_class.join(" "))
  end

  ## Nav Helpers

  def tb_nav(nav_type = nil, content_or_options_with_block = {}, options = {}, &block)
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      content = capture(&block)
    else
      content = content_or_options_with_block
    end

    options = {
        :type => nil, # :tabs, :pills or :list
        :stacked => false,
        :dropdown_menu => false,
        :html => {}
    }.merge(options || {})

    classes = [].tap do |c|
      unless nav_type == :dropdown_menu
        c << "nav"
        c << "nav-#{nav_type.to_s}" unless nav_type.nil?
      else
        c << "dropdown-menu"
      end
      c << "nav-stacked" if options[:stacked]
      c << options[:html][:class] if options[:html][:class]
    end.join(" ")

    options[:html][:class] = classes.blank? ? nil : classes
    content_tag :ul, content, options[:html]
  end

  def tb_nav_item(content_or_options_with_block = nil, options = nil, &block)
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      content = capture(&block)
    else
      content = content_or_options_with_block
    end

    options = {
        :header => false,
        :active => false,
        :disabled => false,
        :dropdown => false,
        :dropdown_submenu => false,
        :html => {}
    }.merge(options || {})

    classes = [].tap do |c|
      if [:divider, :divider_vertical].include?(content)
        c << content.to_s.gsub("_", "-")
        content = nil
      end
      c << options[:html][:class] if options[:html][:class]
      options.except(:html, :nav_header).each_pair do |key, value|
        c << key.to_s.gsub("_", "-") if value
      end
      c << "nav-header" if options[:header]
    end.join(" ")

    options[:html][:class] = classes.blank? ? nil : classes
    content = tb_dropdown_toggle(options[:dropdown]) + content if options[:dropdown]
    content_tag :li, content, options[:html]
  end

  def tb_nav_items(items)
    [].tap do |l|
      items.each_pair do |title, options|
        l << tb_nav_item(tb_link(title, options[:path], options[:link]), options[:nav])
      end
    end.join.html_safe
  end

  def tb_dropdown_toggle(name, options = {})
    options["data-toggle"] = "dropdown"
    options[:class] = "dropdown-toggle #{options[:class]}"
    tb_link "#{name} <b class=\"caret\"></b>".html_safe, "#", options
  end

  ## Modal Helpers

  # Creates a button with the given +name+ that will active a Twitter Bootstrap Modal with the id of +modal_id+.
  # ==== Options
  # * <tt>:data-toggle</tt> - Defaults to modal
  # * All other options are passed to tb_link
  def tb_modal_button(name, modal_id, options=nil)
    options = {
        "data-toggle" => "modal"
    }.merge(options || {})

    tb_link name, "##{modal_id}", options
  end

  # Creates a Twitter Bootstrap modal with the given +modal_id+
  # ==== Options
  # * <tt>:title</tt> - The title at the top of the modal
  # * <tt>:fade</tt> - To specify whether the modal should animate in. Default: true
  # * <tt>:cancel_label</tt> - The name of the cancel button. Default: Cancel
  # * <tt>:cancel_class</tt> - The class of the cancel button. Default: "btn"
  # * <tt>:ok_id</tt> - The id of the ok button. Useful for javascript actions
  # * <tt>:ok_label</tt> - The label of the OK button. Default: OK
  # * <tt>:ok_class</tt> - The class of the OK button. Default: "btn btn-primary"
  # * <tt>:ok_link</tt> - The link for the ok button. Default: "#"
  # * <tt>:remote</tt> - (untested) The remote link for the model to get it's content
  def tb_modal(modal_id, content_or_options_with_block = nil, options = nil, &block)
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      content = capture(&block)
    else
      content = content_or_options_with_block
    end

    options = {
        title: "Alert",
        fade: true,
        cancel_label: "Cancel",
        cancel_class: "btn",
        ok_id: nil,
        ok_label: "OK",
        ok_class: "btn btn-primary",
        ok_link: "#",
        remote: nil,
    }.merge(options || {})

    content_tag :div, :id => modal_id, :class => "modal hide #{ options[:fade] ? "fade" : ""}", "data-remote" => options[:remote] do
      [].tap do |modal|
        modal << content_tag(:div, :class => "modal-header") do
          [].tap do |header|
            header << content_tag(:button, "&times;".html_safe, :class => "close", "data-dismiss" => "modal")
            header << content_tag(:h3, options[:title])
          end.join.html_safe
        end
        modal << content_tag(:div, content, :class => "modal-body")
        modal << content_tag(:div, :class => "modal-footer") do
          [].tap do |footer|
            footer << link_to(options[:cancel_label], "#", "data-dismiss" => "modal", :class => options[:cancel_class])
            footer << link_to(options[:ok_label], options[:ok_link], :class => options[:ok_class], :id => options[:ok_id])
          end.join.html_safe
        end
      end.join.html_safe
    end
  end
end