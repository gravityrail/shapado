desc "Fix all"
task :fixall => [:environment, "fixdb:anonymous"] do
end

namespace :fixdb do
  task :anonymous => [:environment] do
    Question.set({:anonymous => nil}, {:anonymous => false})
    Answer.set({:anonymous => nil}, {:anonymous => false})
  end

  task :clean_memberhips => [:environment] do
    User.find_each do |u|
      count = 0
      new_memberhip_list = u.membership_list
      u.membership_list.each do |group_id, vals|
        if vals["last_activity_at"].nil? || vals["reputation"] == 0.0
          new_memberhip_list.delete(group_id)
          count += 1
        end
      end
      u.set(:membership_list => new_memberhip_list)
      if count > 0
        p "#{u.login}: #{count}"
      end
    end
  end
end

