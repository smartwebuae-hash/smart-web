-- سمارت ويب: شغّل هذا الملف مرة واحدة في Supabase ← SQL Editor
create table if not exists public.services (
  id          bigint generated always as identity primary key,
  name        text not null,
  category    text not null,
  price       numeric,
  old_price   numeric,
  period      text not null default 'once' check (period in ('once','month','year')),
  description text default '',
  features    text[] default '{}',
  badge       text default '',
  sort        int default 0,
  active      boolean default true,
  created_at  timestamptz default now()
);

alter table public.services enable row level security;

-- الزبائن يشاهدون الخدمات الظاهرة فقط
drop policy if exists "public read" on public.services;
create policy "public read" on public.services for select using (active = true);

-- الإدارة (المستخدم المسجّل دخوله) تشاهد وتضيف وتعدّل وتحذف كل شيء
drop policy if exists "admin all" on public.services;
create policy "admin all" on public.services for all to authenticated using (true) with check (true);

-- الخدمات الافتراضية (يمكنك تعديلها لاحقاً من الموقع)
insert into public.services (category,name,price,period,sort,badge,description,features) values
('تصميم المواقع','موقع تعريفي (صفحة هبوط)',999,'once',1,'','صفحة احترافية تعرّف بنشاطك وتوصل الزبون لك مباشرة.','{"تصميم متجاوب مع الجوال","زر واتساب واتصال","ربط خرائط جوجل","تسليم خلال 3 أيام"}'),
('تصميم المواقع','موقع شركة متكامل',2499,'once',2,'الأكثر طلباً','موقع متعدد الصفحات للشركات والإدارات بهوية احترافية.','{"حتى 6 صفحات","دومين واستضافة سنة مجاناً","تهيئة لمحركات البحث SEO","نموذج تواصل وبريد رسمي"}'),
('تصميم المواقع','متجر إلكتروني',3499,'once',3,'','متجر جاهز للبيع أونلاين مع لوحة تحكم سهلة.','{"إضافة منتجات بلا حدود","دفع إلكتروني وعند الاستلام","إدارة الطلبات","تدريب على لوحة التحكم"}'),
('تصميم المواقع','منيو إلكتروني للمطاعم (QR)',799,'once',4,'','منيو بالصور والأسعار والطلب المباشر عبر الواتساب.','{"كود QR للطاولات","أقسام وصور للأطباق","الطلب عبر واتساب","تعديل الأسعار بسهولة"}'),
('إدارة الإنستقرام','إدارة إنستقرام – الباقة الأساسية',999,'month',1,'','نهتم بحسابك بالكامل لتتفرغ لعملك.','{"12 منشور شهرياً بتصميم احترافي","كتابة المحتوى والهاشتاقات","جدولة النشر","تقرير شهري"}'),
('إدارة الإنستقرام','إدارة إنستقرام – الباقة الاحترافية',1799,'month',2,'الأفضل قيمة','نمو أسرع للحساب مع ريلز وستوريات يومية.','{"20 منشور + 4 ريلز شهرياً","ستوري يومي","الرد على الرسائل والتعليقات","إدارة الإعلانات الممولة"}'),
('الاشتراكات الشهرية','اشتراك الاستضافة والصيانة',199,'month',1,'','موقعك يبقى سريعاً وآمناً ومحدثاً دائماً.','{"استضافة سريعة وشهادة SSL","نسخ احتياطي","تعديلات بسيطة شهرياً","دعم فني عبر الواتساب"}'),
('الاشتراكات الشهرية','الاشتراك الشامل',499,'month',2,'بدون دفعة أولى','موقع جاهز بدون دفعة أولى، باشتراك شهري ثابت.','{"تصميم الموقع","الدومين والاستضافة","تحديثات غير محدودة","دعم فني أولوية"}');
