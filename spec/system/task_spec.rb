require 'rails_helper'

RSpec.describe 'Task', type: :system do
  describe 'Task一覧' do
    context '正常系' do
      let(:task) { create(:task, project_id: project.id) }
      let(:project) { create(:project) }

      it '一覧ページにアクセスした場合、Taskが表示されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit project_tasks_path(project)
        expect(page).to have_content task.title
        expect(Task.count).to eq 1
        expect(current_path).to eq project_tasks_path(project)
      end

      it 'Project詳細からTask一覧ページにアクセスした場合、Taskが表示されること' do
        # FIXME: テストが失敗するので修正してください
        project = create(:project)
        task = create(:task, project_id: project.id)
        visit project_path(project)
        click_link 'View Todos'
        switch_to_window(windows.last)
        expect(page).to have_content task.title
        expect(Task.count).to eq 1
        expect(current_path).to eq project_tasks_path(project)
      end
    end
  end

  describe 'Task新規作成' do
    context '正常系' do
      let(:project) { create(:project) }
      let(:task) { create(:task, project_id: project.id) }

      it 'Taskが新規作成されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit project_tasks_path(project)
        click_link 'New Task'
        fill_in 'Title', with: 'test'
        click_button 'Create Task'
        expect(page).to have_content('Task was successfully created.')
        expect(Task.count).to eq 1
        expect(current_path).to eq '/projects/1/tasks/1'
      end
    end
  end

  describe 'Task詳細' do
    context '正常系' do
      it 'Taskが表示されること' do
        # TODO: ローカル変数ではなく let を使用してください
        project = FactoryBot.create(:project)
        task = FactoryBot.create(:task, project_id: project.id)
        visit project_task_path(project, task)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.status)
        expect(page).to have_content(task.deadline.strftime('%Y-%m-%d %H:%M'))
        expect(current_path).to eq project_task_path(project, task)
      end
    end
  end

  describe 'Task編集' do
    context '正常系' do
      it 'Taskを編集した場合、一覧画面で編集後の内容が表示されること' do
        # FIXME: テストが失敗するので修正してください
        project = create(:project)
        task = create(:task, project_id: project.id)
        visit edit_project_task_path(project, task)
        fill_in 'Deadline', with: Time.current
        click_button 'Update Task'
        click_link 'Back'
        expect(page).to have_content(Time.current.strftime('%m/%d'))
        expect(current_path).to eq project_tasks_path(project)
      end

      it 'ステータスを完了にした場合、Taskの完了日に今日の日付が登録されること' do
        # TODO: ローカル変数ではなく let を使用してください
        project = FactoryBot.create(:project)
        task = FactoryBot.create(:task, project_id: project.id)
        visit edit_project_task_path(project, task)
        select 'done', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content('done')
        expect(page).to have_content(Time.current.strftime('%Y-%m-%d'))
        expect(current_path).to eq project_task_path(project, task)
      end

      it '既にステータスが完了のタスクのステータスを変更した場合、Taskの完了日が更新されないこと' do
        # TODO: FactoryBotのtraitを利用してください
        project = FactoryBot.create(:project)
        task = FactoryBot.create(:task, project_id: project.id, status: :done, completion_date: Time.current.yesterday)
        visit edit_project_task_path(project, task)
        select 'todo', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content('todo')
        expect(page).not_to have_content(Time.current.strftime('%Y-%m-%d'))
        expect(current_path).to eq project_task_path(project, task)
      end
    end
  end

  describe 'Task削除' do
    context '正常系' do
      # FIXME: テストが失敗するので修正してください
      it 'Taskが削除されること' do
        project = create(:project)
        task = create(:task, project_id: project.id)
        visit project_tasks_path(project)
        click_link 'Destroy'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task was successfully destroyed'
        expect(Task.count).to eq 0
        expect(current_path).to eq project_tasks_path(project)
      end
    end
  end
end
