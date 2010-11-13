class Widget
  include Mongoid::Document

  identity :type => String
  field :name, :type => String, :required => true
  field :settings, :type => Hash

  validate :set_name, :on => :create
  embedded_in :group, :inverse_of => [:question_widgets, :mainlist_widgets, :welcome_widgets]

  def initialize(*args)
    super(*args)

    self[:name] ||= self.class.to_s.sub("Widget", "").underscore
  end

  def self.types(tab)
    types = %w[UsersWidget BadgesWidget TopUsersWidget TagCloudWidget PagesWidget SharingButtonsWidget CurrentTagsWidget TagListWidget]
    if tab == 'question'
      types += %w[ModInfoWidget QuestionTagsWidget QuestionBadgesWidget QuestionStatsWidget RelatedQuestionsWidget]
    end
    if AppConfig.enable_groups
      types += %w[GroupsWidget TopGroupsWidget]
    end

    types
  end

  def question_only?
    false
  end

  def partial_name
    "widgets/#{self.name}"
  end

  def up
    self.move_to("up")
  end

  def down
    self.move_to("down")
  end

  def move_to(pos, widgets, context)
    pos ||= "up"
    current_pos = widgets.index(self)

    if pos == "up"
      pos = current_pos-1
    elsif pos == "down"
      pos = current_pos+1
    end

    if pos >= widgets.count
      pos = 0
    elsif pos < 0
      pos = widgets.count-1
    end

    widgets[current_pos], widgets[pos] = widgets[pos], widgets[current_pos]
    self.group.send(:"#{context}_widgets=", widgets)
    self.group.raw_save(:force => true)
  end

  def update_settings(params)
    ##TODO: check what's going in
    self.settings = params[:settings]
  end

  def description
    @description ||= I18n.t("widgets.#{self.name}.description") if self.name
  end

  protected
end

