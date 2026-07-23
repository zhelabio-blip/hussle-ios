from pathlib import Path
from PIL import Image
import sys
root = Path(__file__).resolve().parents[1]
app_root = root / 'HussleApp'
errors=[]
required=[
'HussleApp/Hussle/ViewModels/AppStore.swift','HussleApp/Hussle/ViewModels/AppStore+DemoExit.swift','HussleApp/Hussle/Views/Onboarding/AuthView.swift','HussleApp/Hussle/Views/Onboarding/OnboardingView.swift',
'HussleApp/Hussle/Views/Components/DemoExitControl.swift','HussleApp/Hussle/Views/Discover/DiscoverView.swift','HussleApp/Hussle/Views/Discover/DogProfileView.swift','HussleApp/Hussle/Views/Matches/MatchView.swift',
'HussleApp/Hussle/Views/Matches/MatchesView.swift','HussleApp/Hussle/Views/Messages/MessagesView.swift','HussleApp/Hussle/Views/Profile/ProfileView.swift',
'HussleApp/Hussle/Services/AuthService.swift','HussleApp/Hussle/Services/ProfileRepository.swift','HussleApp/Hussle/Services/StorageService.swift',
'HussleApp/Hussle/Services/RealtimeChatService.swift','Supabase/migrations/0001_hussle_backend_bootstrap.sql'
]
for rel in required:
 if not (root/rel).exists(): errors.append(f'Missing {rel}')
app=(app_root/'Hussle/ViewModels/AppStore.swift').read_text()
checks={
'demo enters onboarding':'func continueInDemoMode()' in app and 'launchState = .onboarding' in app.split('func continueInDemoMode()',1)[1].split('func signOut',1)[0],
'demo does not jump main':'launchState = .main' not in app.split('func continueInDemoMode()',1)[1].split('func signOut',1)[0],
'email confirmation handled':'emailConfirmationRequired' in app,
}
for name,ok in checks.items():
 if not ok: errors.append(name)
auth=(app_root/'Hussle/Views/Onboarding/AuthView.swift').read_text()
if 'demoModeButton' not in auth: errors.append('Demo button identifier missing')
onb=(app_root/'Hussle/Views/Onboarding/OnboardingView.swift').read_text()
for token in ['Your name','Your photo','What are you looking for?','Dog’s name','Vaccinations','Find dogs nearby','Create profile']:
 if token not in onb: errors.append(f'Onboarding token missing: {token}')
match=(app_root/'Hussle/Views/Matches/MatchView.swift').read_text()
if match.count('dogMatchPortrait(') < 3 or 'owner' in match.lower(): errors.append('Match is not visibly dog-to-dog')
exit_store=(app_root/'Hussle/ViewModels/AppStore+DemoExit.swift').read_text()
for token in ['func exitDemoMode() async','guard isDemoMode else','await signOut()','discoveryPreferences = DiscoveryPreferences()']:
 if token not in exit_store: errors.append(f'Exit Demo reset contract missing: {token}')
exit_control=(app_root/'Hussle/Views/Components/DemoExitControl.swift').read_text()
for token in ['Exit Demo','exitDemoButton','safeAreaInset','store.isDemoMode']:
 if token not in exit_control: errors.append(f'Exit Demo control contract missing: {token}')
root_view=(app_root/'Hussle/Views/RootView.swift').read_text()
if '.demoExitControl()' not in root_view: errors.append('Exit Demo is not attached to the root Demo flow')
modal_contracts={
 'Match':'Hussle/Views/Matches/MatchView.swift',
 'Report':'Hussle/Views/Safety/ReportView.swift',
 'Vaccinations':'Hussle/Views/Profile/VaccinationsEditorView.swift',
}
for name,rel in modal_contracts.items():
 text=(app_root/rel).read_text()
 if '.demoExitControl' not in text: errors.append(f'Exit Demo missing from {name} modal flow')
dog_editor=(app_root/'Hussle/Views/Profile/DogEditorView.swift').read_text()
if 'showsDemoExit: true' not in dog_editor: errors.append('Vaccination modal is not configured to show Exit Demo')
expected_names = {
 'dog-charlie.png','dog-luna.png','dog-milo.png','dog-buddy.png','dog-coco.png','dog-zoe.png','dog-max.png','dog-nala.png',
 'owner-tony.png','owner-anna.png','owner-james.png','owner-minh.png','owner-sophie.png','owner-emma.png','owner-daniel.png','owner-olivia.png'
}
imgs=sorted((app_root/'Hussle/Resources/DemoImages').glob('*.png'))
actual_names={f.name for f in imgs}
if actual_names != expected_names:
 errors.append(f'Demo image set mismatch. Missing: {sorted(expected_names-actual_names)} Extra: {sorted(actual_names-expected_names)}')
for f in imgs:
 try:
  im=Image.open(f); im.verify()
  im=Image.open(f)
  min_side=1000
  if min(im.size)<min_side: errors.append(f'Low resolution {f.name}: {im.size}')
 except Exception as e: errors.append(f'Unreadable {f.name}: {e}')
art=(app_root/'Hussle/Views/Components/DogArtwork.swift').read_text()
for token in ['scaledToFill','clipShape(Circle())','DogOwnerPortrait']:
 if token not in art: errors.append(f'Image rendering contract missing: {token}')
mock=(app_root/'Hussle/Services/MockData.swift').read_text()
for token in ['name: "Max"','name: "Nala"','breed: "Golden Retriever"','breed: "Cavalier King Charles Spaniel"','ownerName: "Olivia"']:
 if token not in mock: errors.append(f'Demo mapping missing: {token}')
discover=(app_root/'Hussle/Views/Discover/DiscoverView.swift').read_text()
for token in ['activityStatus','recommendationReason']:
 if token not in discover: errors.append(f'Demo quality UI missing: {token}')
migs=list((root/'Supabase/migrations').glob('*.sql'))
if len(migs)!=1: errors.append(f'Expected one canonical migration, found {len(migs)}')
all_sql='\n'.join(x.read_text() for x in migs).lower()
if 'delete from storage.objects' in all_sql or 'delete from storage.buckets' in all_sql: errors.append('Forbidden direct Storage delete found')
if errors:
 print('RELEASE GATE FAILED')
 for e in errors: print('-',e)
 sys.exit(1)
print('RELEASE GATE PASSED')
print('Required functionality, approved Demo entry, Exit Demo coverage, image assets, backend structure and critical visual contracts are present.')
