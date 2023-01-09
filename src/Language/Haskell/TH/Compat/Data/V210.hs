module Language.Haskell.TH.Compat.Data.V210 (
  dataD', unDataD,
  newtypeD', unNewtypeD,
  dataInstD', unDataInstD,
  newtypeInstD', unNewtypeInstD,
  unInstanceD, plainTVSpec, tyVarBndrName
  ) where

import Language.Haskell.TH
  (CxtQ, ConQ, TypeQ, DecQ,
   Cxt, Con, Type (ConT), Name, TyVarBndr (PlainTV, KindedTV), Kind,
   Dec (DataD, NewtypeD, DataInstD, NewtypeInstD, InstanceD),
   dataD, newtypeD, dataInstD, newtypeInstD)

import Language.Haskell.TH.Compat.Data.Util (foldAppT_)


-- | Definition against 'dataD',
--   compatible with before temaplate-haskell-2.11
dataD' :: CxtQ -> Name -> [TyVarBndr] -> [ConQ] -> [Name]
       -> DecQ
dataD' = dataD

-- | Compatible interface to destruct 'DataD'
unDataD :: Dec -> Maybe (Cxt, Name, [TyVarBndr], Maybe Kind, [Con], [Type])
unDataD (DataD cxt n bs cs ds) = Just (cxt, n, bs, Nothing, cs, map ConT ds)
unDataD  _                     = Nothing

-- | Definition against 'newtypeD',
--   compatible with before temaplate-haskell-2.11
newtypeD' :: CxtQ -> Name -> [TyVarBndr] -> ConQ -> [Name]
          -> DecQ
newtypeD' = newtypeD

-- | Compatible interface to destruct 'NewtypeD'
unNewtypeD :: Dec -> Maybe (Cxt, Name, [TyVarBndr], Maybe Kind, Con, [Type])
unNewtypeD (NewtypeD cxt n bs c ds) = Just (cxt, n, bs, Nothing, c, map ConT ds)
unNewtypeD  _                       = Nothing

-- | Definition against 'dataInstD',
--   compatible with before temaplate-haskell-2.11
dataInstD' :: CxtQ -> Name -> [TypeQ] -> [ConQ] -> [Name]
           -> DecQ
dataInstD' = dataInstD

-- | Compatible interface to destruct 'DataInstD'
unDataInstD :: Dec -> Maybe (Cxt, Maybe [TyVarBndr], Type, Maybe Kind, [Con], [Type])
unDataInstD (DataInstD cxt n as cs ds) = Just (cxt, Nothing, foldAppT_ n as, Nothing, cs, map ConT ds)
unDataInstD  _                         = Nothing

-- | Definition against 'newtypeInstD',
--   compatible with before temaplate-haskell-2.11
newtypeInstD' :: CxtQ -> Name -> [TypeQ] -> ConQ -> [Name]
              -> DecQ
newtypeInstD' = newtypeInstD

-- | Compatible interface to destruct 'NewtypeInstD'
unNewtypeInstD :: Dec -> Maybe (Cxt, Maybe [TyVarBndr], Type, Maybe Kind, Con, [Type])
unNewtypeInstD (NewtypeInstD cxt n as c ds) = Just (cxt, Nothing, foldAppT_ n as, Nothing, c, map ConT ds)
unNewtypeInstD  _                           = Nothing

-- | Compatible interface to destruct 'InstanceD'.
--   No Overlap type is defined before template-haskell-2.11.
unInstanceD :: Dec -> Maybe (Cxt, Type, [Dec])
unInstanceD (InstanceD cxt ty decs) = Just (cxt, ty, decs)
unInstanceD  _                      = Nothing

-- | Construct a 'PlainTV' with a 'SpecifiedSpec' (template-haskell-2.17)
plainTVSpec :: Name -> TyVarBndr
plainTVSpec n = PlainTV n

-- | Compatible interface to extract the type variable name from a 'TyVarBndr'
tyVarBndrName :: TyVarBndr -> Name
tyVarBndrName (PlainTV n) = n
tyVarBndrName (KindedTV n _) = n
