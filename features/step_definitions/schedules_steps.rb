# encoding: utf-8

Alors /^je vois (\d+) comme étant le nombre de cours par horaire affiché$/ do |courses_per_schedule|
  expect(page).to have_field("Nombre de cours par horaire", with: courses_per_schedule)
end

Alors /^je vois (.+) comme étant les cours sélectionnés$/ do |courses_list|
  courses = courses_list.split(/, | et /)
  courses.each { |course| expect(page).to have_css(".label", text: course) }
end

Alors(/^je vois (\d+) possibilités d'horaires$/) do |count|
  expect(page).to have_selector(".schedules fieldset", count: count)
end

Alors /^je vois les horaires:$/ do |table|
  schedules = find(".schedules").all("fieldset")

  table.hashes.each do |row|
    weekday_index = I18n.t("date.day_names").index(row["Jour"].downcase)

    actual_schedule = schedules.find do |schedule|
      schedule.has_css?("legend", text: "Horaire - #{row["Numéro d'horaire"]}")
    end
    weekday = actual_schedule.find(".weekday-#{weekday_index}")

    actual_period = weekday.all(".period").find do |period|
      period.has_css?("div", text: row["Période"]) &&
      period.has_css?("div", text: row["Cours"]) &&
      period.has_css?("div", text: row["Type"])
    end
    fail "Unable to find period #{row}" if actual_period.nil?
  end
end

Lorsque /^que j'édite l'agenda$/ do
  click_link "Éditer"
end
