require 'onepageapi'
require 'json_spec'
require 'pry'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Create and update predefined actions' do 
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  it 'should return predefined actions' do
    response = samples.get('predefined_actions.json')
    expect(response['status']).to be 0
    expect(response['data'].to_json).to have_json_path('predefined_actions')
  end

  it 'should add a predefined action' do
    response = samples.post('predefined_actions.json', 'text' => 'hello', 'days' => 5)
    expect(response['status']).to be 0
    expect(response['data']['predefined_action']['text']).to eq 'hello'
    expect(response['data']['predefined_action']['days']).to eq 5
  end

  it 'should not add a predefined action because days is negative' do 
    response = samples.post('predefined_actions.json', 'text' => 'negative', 'days' => -4)
    expect(response['status']).to be 400
  end

  it 'should not add a predefined action because days doesn\'t exist' do 
    response = samples.post('predefined_actions.json', 'text' => 'no days')
    expect(response['status']).to be 400
  end

  it 'should not add a predefined action because text doesn\'t exist' do 
    response = samples.post('predefined_actions.json', 'days' => '1')
    puts response
    expect(response['status']).to be 400
  end

  it 'should update a predefined action' do
    predefined_actions = samples.get('predefined_actions.json')['data']['predefined_actions']
    last_id = predefined_actions.last['predefined_action']['id']
    response = samples.put("predefined_actions/#{last_id}.json", 'text' => 'goodbye', 'days' => 10)
    expect(response['status']).to be 0
    expect(response['data']['predefined_action']['text']).to eq 'goodbye'
    expect(response['data']['predefined_action']['days']).to eq 10
  end

  it 'should delete the predefined action' do
    predefined_actions = samples.get('predefined_actions.json')['data']['predefined_actions']
    last_id = predefined_actions.last['predefined_action']['id']
    response = samples.delete("predefined_actions/#{last_id}.json")
    expect(response['status']).to be 0
  end

end