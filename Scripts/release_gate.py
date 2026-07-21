from pathlib import Path
from PIL import Image
import sys
root = Path(__file__).resolve().parents[1]
errors=[]
required=[
'Hussle/ViewModels/AppStore.swift','Hussle/Views/Onboarding/AuthView.swift','Hussle/Views/Onboarding/OnboardingView.swift',
'Hussle/Views/Discover/DiscoverView.swift','Hussle/Views/Discover/DogProfileView.swift','Hussle/Views/Matches/MatchView.swift',
'Hussle/Views/Matches/MatchesView.swift','Hussle/Views/Messages/MessagesView.swift','Hussle/Views/Profile/ProfileView.swift',
'Hussle/Services/AuthService.swift','Hussle/Services/ProfileRepository.swift','Hussle/Services/StorageService.swift',
'Hussle/Services/RealtimeChatService.swift','Supabase/migrations/0001_hussle_backend_bootstrap.sql'
]
for rel in required:
 if not (root/rel).exists(): errors.append(f'Missing {rel}')
app=(root/'Hussle/ViewModels/AppStore.swift').read_text()
checks={
'demo enters onboarding':'func continueInDemoMode()' in app and 'launchState = .onboarding' in app.split('func continueInDemoMode()',1)[1].split('func signOut',1)[0],
'demo does not jump main':'launchState = .main' not in app.split('func continueInDemoMode()',1)[1].split('func signOut',1)[0],
'email confirmation handled':'emailConfirmationRequired' in app,
}
for name,ok in checks.items():
 if not ok: errors.append(name)
auth=(root/'Hussle/Views/Onboarding/AuthView.swift').read_text()
if 'demoModeButton' not in auth: errors.append('Demo button identifier missing')
onb=(root/'Hussle/Views/Onboarding/OnboardingView.swift').read_text()
for token in ['Your name','Your photo','What are you looking for?','Dog’s name','Vaccinations','Find dogs nearby','Create profile']:
 if token not in onb: errors.append(f'Onboarding token missing: {token}')
match=(root/'Hussle/Views/Matches/MatchView.swift').read_text()
if match.count('dogMatchPortrait(') < 3 or 'owner' in match.lower(): errors.append('Match is not visibly dog-to-dog')
imgs=sorted((root/'Hussle/Resources/DemoImages').glob('*.jpg'))
if len(imgs)!=12: errors.append(f'Expected 12 demo images, found {len(imgs)}')
for f in imgs:
 try:
  im=Image.open(f); im.verify()
  im=Image.open(f)
  min_side=1200 if f.name.startswith('owner-') else 1600
  if min(im.size)<min_side: errors.append(f'Low resolution {f.name}: {im.size}')
 except Exception as e: errors.append(f'Unreadable {f.name}: {e}')
art=(root/'Hussle/Views/Components/DogArtwork.swift').read_text()
for token in ['scaledToFill','clipShape(Circle())','DogOwnerPortrait']:
 if token not in art: errors.append(f'Image rendering contract missing: {token}')
migs=list((root/'Supabase/migrations').glob('*.sql'))
if len(migs)!=1: errors.append(f'Expected one canonical migration, found {len(migs)}')
all_sql='\n'.join(x.read_text() for x in migs).lower()
if 'delete from storage.objects' in all_sql or 'delete from storage.buckets' in all_sql: errors.append('Forbidden direct Storage delete found')
if errors:
 print('RELEASE GATE FAILED')
 for e in errors: print('-',e)
 sys.exit(1)
print('RELEASE GATE PASSED')
print('Required functionality, approved Demo entry, image assets, backend structure and critical visual contracts are present.')
